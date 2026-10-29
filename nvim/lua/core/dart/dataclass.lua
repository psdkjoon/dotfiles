local M = {}

local PRIMITIVE = { String = true, int = true, double = true, num = true, bool = true, dynamic = true, Object = true }
local CLASS_MODIFIERS = { abstract = true, final = true, base = true, sealed = true, interface = true, mixin = true }

local function strip_nullable(ty)
	if ty:sub(-1) == "?" then
		return ty:sub(1, -2), true
	end
	return ty, false
end

local function is_collection(ty)
	local base = strip_nullable(ty)
	return base:match("^List<") or base:match("^Set<") or base:match("^Map<") or base:match("^Iterable<")
end

local function ser(ty, e)
	local base, nullable = strip_nullable(ty)
	local q = nullable and "?" or ""
	if PRIMITIVE[base] then
		return e
	end
	if base == "DateTime" then
		return e .. q .. ".toIso8601String()"
	end
	local kind, arg = base:match("^(%a+)<(.+)>$")
	if kind == "List" or kind == "Set" or kind == "Iterable" then
		local inner = ser(arg, "e")
		if inner == "e" then
			return kind == "List" and e or (e .. q .. ".toList()")
		end
		return e .. q .. ".map((e) => " .. inner .. ").toList()"
	end
	if kind == "Map" then
		local val = arg:match("^%s*[^,]+,%s*(.+)$")
		local inner = val and ser(val, "v") or "v"
		if inner == "v" then
			return e
		end
		return e .. q .. ".map((k, v) => MapEntry(k, " .. inner .. "))"
	end
	return e .. q .. ".toMap()"
end

local function is_simple(ty)
	local base = strip_nullable(ty)
	return PRIMITIVE[base] and base ~= "double"
end

local function de(ty, v)
	local base, nullable = strip_nullable(ty)
	local body
	if base == "dynamic" then
		return v
	elseif base == "double" then
		body = "(" .. v .. " as num).toDouble()"
	elseif PRIMITIVE[base] then
		body = v .. " as " .. base
	elseif base == "DateTime" then
		body = "DateTime.parse(" .. v .. " as String)"
	else
		local kind, arg = base:match("^(%a+)<(.+)>$")
		if kind == "List" or kind == "Set" or kind == "Iterable" then
			local ctor = kind == "Set" and "Set" or "List"
			if is_simple(arg) then
				body = ctor .. "<" .. arg .. ">.from(" .. v .. " as List)"
			else
				body = ctor .. "<" .. arg .. ">.from((" .. v .. " as List).map((e) => " .. de(arg, "e") .. "))"
			end
		elseif kind == "Map" then
			local val = arg:match("^%s*[^,]+,%s*(.+)$")
			if val and is_simple(val) then
				body = "Map<" .. arg .. ">.from(" .. v .. " as Map)"
			elseif val then
				body = "(" .. v .. " as Map<String, dynamic>).map((k, v) => MapEntry(k, " .. de(val, "v") .. "))"
			else
				body = v
			end
		else
			body = base:match("^[%w_]+") .. ".fromMap(" .. v .. " as Map<String, dynamic>)"
		end
	end
	if nullable then
		return v .. " != null ? " .. body .. " : null"
	end
	return body
end

local function clean(line)
	line = line:gsub("\\.", "")
	line = line:gsub("'[^']*'", "''")
	line = line:gsub('"[^"]*"', '""')
	line = line:gsub("//.*$", "")
	return line
end

local function parse_header(line)
	local mods, name = line:match("^%s*([%a%s]-)class%s+([%w_]+)")
	if not name then
		return nil
	end
	local abstract = false
	for w in mods:gmatch("%a+") do
		if not CLASS_MODIFIERS[w] then
			return nil
		end
		if w == "abstract" or w == "sealed" or w == "interface" or w == "mixin" then
			abstract = true
		end
	end
	local generics = line:match("^%s*[%a%s]-class%s+[%w_]+(%b<>)")
	if generics then
		generics = generics:gsub("%s+extends%s+[^,>]+", "")
	end
	return { name = name, generics = generics, abstract = abstract }
end

local function parse_field(c)
	local decl = c:match("^%s*(.-)%s*;%s*$")
	if not decl or decl == "" or decl:find("[%(=]") then
		return nil
	end
	if decl:match("^static%s") or decl:match("^const%s") or decl:match("^late%s") or decl:match("^external%s") then
		return nil
	end
	local is_final = false
	if decl:match("^final%s") then
		is_final = true
		decl = decl:gsub("^final%s+", "")
	end
	local ty, nm = decl:match("^(.-)%s+([%a_][%w_]*)$")
	if not ty or ty == "" or ty:sub(-1) == "," then
		return nil
	end
	if ty:match("%f[%w]get$") or ty:match("%f[%w]set$") then
		return nil
	end
	if ty == "var" then
		ty = "dynamic"
	end
	local _, nullable = strip_nullable(ty)
	return { type = ty, name = nm, final = is_final, nullable = nullable }
end

function M.parse(lines, cursor_row)
	local start, header
	for i = math.min(cursor_row, #lines), 1, -1 do
		header = parse_header(lines[i])
		if header then
			start = i
			break
		end
	end
	if not header then
		return nil, "Cursor is not inside a class"
	end
	if header.abstract then
		return nil, header.name .. " is abstract/sealed/mixin; nothing to generate"
	end

	local name = header.name
	local depth, body_started = 0, false
	local fields, cleaned, has_ctor, end_row = {}, {}, false, nil

	for i = start, #lines do
		local c = clean(lines[i])
		cleaned[#cleaned + 1] = c
		local depth_before = depth
		local _, opens = c:gsub("{", "")
		local _, closes = c:gsub("}", "")
		depth = depth + opens - closes

		if body_started and depth_before == 1 then
			if c:find("%f[%w_]" .. name .. "%s*%(") then
				has_ctor = true
			end
			if opens == 0 and closes == 0 then
				local f = parse_field(c)
				if f then
					fields[#fields + 1] = f
				end
			end
		end

		if opens > 0 then
			body_started = true
		end
		if body_started and depth <= 0 then
			end_row = i
			break
		end
	end

	if not end_row then
		return nil, "Couldn't find the end of class " .. name
	end
	if not lines[end_row]:match("^%s*}%s*$") then
		return nil, "Closing brace of " .. name .. " must be on its own line"
	end
	if cursor_row > end_row then
		return nil, "Cursor is not inside class " .. name
	end
	if #fields == 0 then
		return nil, "No instance fields found in " .. name
	end
	for _, f in ipairs(fields) do
		if f.name:sub(1, 1) == "_" then
			return nil, "Private field '" .. f.name .. "' can't be a named constructor parameter; rename it or write this class by hand"
		end
	end

	local body = table.concat(cleaned, "\n")
	return {
		name = name,
		generics = header.generics,
		indent = lines[start]:match("^%s*"),
		fields = fields,
		end_row = end_row,
		has = {
			ctor = has_ctor,
			copyWith = body:find("copyWith%s*%(") ~= nil,
			toString = body:find("toString%s*%(") ~= nil,
			eq = body:find("operator%s*==") ~= nil,
			hash = body:find("hashCode") ~= nil,
			toMap = body:find("toMap%s*%(") ~= nil,
			fromMap = body:find("fromMap%s*%(") ~= nil,
			toJson = body:find("toJson%s*%(") ~= nil,
			fromJson = body:find("fromJson%s*%(") ~= nil,
		},
	}
end

function M.build(info, mode)
	local name, fields, has = info.name, info.fields, info.has
	local self_type = name .. (info.generics or "")
	local out, notes, imports = {}, {}, {}
	local function add(s)
		out[#out + 1] = s
	end
	local function skipped(what)
		notes[#notes + 1] = "kept existing " .. what
	end
	local uses_collection_eq = false

	if has.ctor then
		skipped("constructor")
	else
		local all_final = true
		for _, f in ipairs(fields) do
			all_final = all_final and f.final
		end
		add("")
		add("  " .. (all_final and "const " or "") .. name .. "({")
		for _, f in ipairs(fields) do
			local optional = f.nullable or f.type == "dynamic"
			add("    " .. (optional and "" or "required ") .. "this." .. f.name .. ",")
		end
		add("  });")
	end

	if has.copyWith then
		skipped("copyWith")
	else
		add("")
		add("  " .. self_type .. " copyWith({")
		for _, f in ipairs(fields) do
			local t = (f.nullable or f.type == "dynamic") and f.type or (f.type .. "?")
			add("    " .. t .. " " .. f.name .. ",")
		end
		add("  }) {")
		add("    return " .. name .. "(")
		for _, f in ipairs(fields) do
			add("      " .. f.name .. ": " .. f.name .. " ?? this." .. f.name .. ",")
		end
		add("    );")
		add("  }")
	end

	if has.eq or has.hash then
		skipped("== / hashCode")
	else
		local eqs, hs = {}, {}
		for _, f in ipairs(fields) do
			if is_collection(f.type) then
				uses_collection_eq = true
				eqs[#eqs + 1] = "const DeepCollectionEquality().equals(other." .. f.name .. ", " .. f.name .. ")"
				hs[#hs + 1] = "const DeepCollectionEquality().hash(" .. f.name .. ")"
			else
				eqs[#eqs + 1] = "other." .. f.name .. " == " .. f.name
				hs[#hs + 1] = f.name
			end
		end
		add("")
		add("  @override")
		add("  bool operator ==(Object other) {")
		add("    if (identical(this, other)) return true;")
		add("    return other is " .. self_type .. " &&")
		for i, e in ipairs(eqs) do
			add("        " .. e .. (i < #eqs and " &&" or ";"))
		end
		add("  }")
		add("")
		add("  @override")
		if #hs == 1 then
			local single = is_collection(fields[1].type) and hs[1] or (hs[1] .. ".hashCode")
			add("  int get hashCode => " .. single .. ";")
		elseif #hs <= 20 then
			add("  int get hashCode => Object.hash(" .. table.concat(hs, ", ") .. ");")
		else
			add("  int get hashCode => Object.hashAll([" .. table.concat(hs, ", ") .. "]);")
		end
	end

	if has.toString then
		skipped("toString")
	else
		local parts = {}
		for _, f in ipairs(fields) do
			parts[#parts + 1] = f.name .. ": $" .. f.name
		end
		add("")
		add("  @override")
		add("  String toString() {")
		add("    return '" .. name .. "(" .. table.concat(parts, ", ") .. ")';")
		add("  }")
	end

	if mode == "all" then
		if info.generics then
			notes[#notes + 1] = "skipped toMap/fromMap: generic classes need hand-written (de)serialisation"
		else
			if has.toMap then
				skipped("toMap")
			else
				add("")
				add("  Map<String, dynamic> toMap() {")
				add("    return {")
				for _, f in ipairs(fields) do
					add("      '" .. f.name .. "': " .. ser(f.type, f.name) .. ",")
				end
				add("    };")
				add("  }")
			end

			if has.fromMap then
				skipped("fromMap")
			else
				add("")
				add("  factory " .. name .. ".fromMap(Map<String, dynamic> map) {")
				add("    return " .. name .. "(")
				for _, f in ipairs(fields) do
					add("      " .. f.name .. ": " .. de(f.type, "map['" .. f.name .. "']") .. ",")
				end
				add("    );")
				add("  }")
			end

			local wrote_json = false
			if has.toJson then
				skipped("toJson")
			else
				add("")
				add("  String toJson() => json.encode(toMap());")
				wrote_json = true
			end
			if has.fromJson then
				skipped("fromJson")
			else
				add("")
				add("  factory " .. name .. ".fromJson(String source) =>")
				add("      " .. name .. ".fromMap(json.decode(source) as Map<String, dynamic>);")
				wrote_json = true
			end
			if wrote_json then
				imports[#imports + 1] = "import 'dart:convert';"
			end
		end
	end

	if uses_collection_eq then
		imports[#imports + 1] = "import 'package:collection/collection.dart';"
		notes[#notes + 1] = "collection fields use DeepCollectionEquality; make sure `collection` is a dependency (:PubAdd collection)"
	end

	for i, l in ipairs(out) do
		if l ~= "" then
			out[i] = info.indent .. l
		end
	end
	return out, notes, imports
end

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "DartDataClass" })
end

local function ensure_import(buf, stmt)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local last_import
	for i, l in ipairs(lines) do
		if l:find(stmt, 1, true) then
			return
		end
		if l:match("^import%s") or l:match("^export%s") then
			last_import = i
		end
	end
	if last_import then
		vim.api.nvim_buf_set_lines(buf, last_import, last_import, false, { stmt })
	else
		vim.api.nvim_buf_set_lines(buf, 0, 0, false, { stmt, "" })
	end
end

function M.generate(mode)
	mode = mode or "basic"
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].filetype ~= "dart" then
		return notify("Not a Dart buffer", vim.log.levels.WARN)
	end

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local info, err = M.parse(lines, row)
	if not info then
		return notify(err, vim.log.levels.WARN)
	end

	local out, notes, imports = M.build(info, mode)
	if #out == 0 then
		return notify("Nothing to generate for " .. info.name .. " (" .. table.concat(notes, "; ") .. ")")
	end

	local at = info.end_row - 1
	vim.api.nvim_buf_set_lines(buf, at, at, false, out)
	for _, stmt in ipairs(imports) do
		ensure_import(buf, stmt)
	end

	local msg = "Generated members for " .. info.name
	if #notes > 0 then
		msg = msg .. "\n- " .. table.concat(notes, "\n- ")
	end
	notify(msg)
end

return M
