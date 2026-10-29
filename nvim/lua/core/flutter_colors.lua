local M = {}

local SHADES = { 50, 100, 200, 300, 400, 500, 600, 700, 800, 900 }
local ACCENT_SHADES = { 100, 200, 400, 700 }

local SWATCHES = {
	red = "FFEBEE FFCDD2 EF9A9A E57373 EF5350 F44336 E53935 D32F2F C62828 B71C1C",
	pink = "FCE4EC F8BBD0 F48FB1 F06292 EC407A E91E63 D81B60 C2185B AD1457 880E4F",
	purple = "F3E5F5 E1BEE7 CE93D8 BA68C8 AB47BC 9C27B0 8E24AA 7B1FA2 6A1B9A 4A148C",
	deepPurple = "EDE7F6 D1C4E9 B39DDB 9575CD 7E57C2 673AB7 5E35B1 512DA8 4527A0 311B92",
	indigo = "E8EAF6 C5CAE9 9FA8DA 7986CB 5C6BC0 3F51B5 3949AB 303F9F 283593 1A237E",
	blue = "E3F2FD BBDEFB 90CAF9 64B5F6 42A5F5 2196F3 1E88E5 1976D2 1565C0 0D47A1",
	lightBlue = "E1F5FE B3E5FC 81D4FA 4FC3F7 29B6F6 03A9F4 039BE5 0288D1 0277BD 01579B",
	cyan = "E0F7FA B2EBF2 80DEEA 4DD0E1 26C6DA 00BCD4 00ACC1 0097A7 00838F 006064",
	teal = "E0F2F1 B2DFDB 80CBC4 4DB6AC 26A69A 009688 00897B 00796B 00695C 004D40",
	green = "E8F5E9 C8E6C9 A5D6A7 81C784 66BB6A 4CAF50 43A047 388E3C 2E7D32 1B5E20",
	lightGreen = "F1F8E9 DCEDC8 C5E1A5 AED581 9CCC65 8BC34A 7CB342 689F38 558B2F 33691E",
	lime = "F9FBE7 F0F4C3 E6EE9C DCE775 D4E157 CDDC39 C0CA33 AFB42B 9E9D24 827717",
	yellow = "FFFDE7 FFF9C4 FFF59D FFF176 FFEE58 FFEB3B FDD835 FBC02D F9A825 F57F17",
	amber = "FFF8E1 FFECB3 FFE082 FFD54F FFCA28 FFC107 FFB300 FFA000 FF8F00 FF6F00",
	orange = "FFF3E0 FFE0B2 FFCC80 FFB74D FFA726 FF9800 FB8C00 F57C00 EF6C00 E65100",
	deepOrange = "FBE9E7 FFCCBC FFAB91 FF8A65 FF7043 FF5722 F4511E E64A19 D84315 BF360C",
	brown = "EFEBE9 D7CCC8 BCAAA4 A1887F 8D6E63 795548 6D4C41 5D4037 4E342E 3E2723",
	grey = "FAFAFA F5F5F5 EEEEEE E0E0E0 BDBDBD 9E9E9E 757575 616161 424242 212121",
	blueGrey = "ECEFF1 CFD8DC B0BEC5 90A4AE 78909C 607D8B 546E7A 455A64 37474F 263238",
}

local ACCENTS = {
	red = "FF8A80 FF5252 FF1744 D50000",
	pink = "FF80AB FF4081 F50057 C51162",
	purple = "EA80FC E040FB D500F9 AA00FF",
	deepPurple = "B388FF 7C4DFF 651FFF 6200EA",
	indigo = "8C9EFF 536DFE 3D5AFE 304FFE",
	blue = "82B1FF 448AFF 2979FF 2962FF",
	lightBlue = "80D8FF 40C4FF 00B0FF 0091EA",
	cyan = "84FFFF 18FFFF 00E5FF 00B8D4",
	teal = "A7FFEB 64FFDA 1DE9B6 00BFA5",
	green = "B9F6CA 69F0AE 00E676 00C853",
	lightGreen = "CCFF90 B2FF59 76FF03 64DD17",
	lime = "F4FF81 EEFF41 C6FF00 AEEA00",
	yellow = "FFFF8D FFFF00 FFEA00 FFD600",
	amber = "FFE57F FFD740 FFC400 FFAB00",
	orange = "FFD180 FFAB40 FF9100 FF6D00",
	deepOrange = "FF9E80 FF6E40 FF3D00 DD2C00",
}

local SINGLES = {
	black = "000000",
	black87 = "000000",
	black54 = "000000",
	black45 = "000000",
	black38 = "000000",
	black26 = "000000",
	black12 = "000000",
	white = "FFFFFF",
	white70 = "FFFFFF",
	white60 = "FFFFFF",
	white54 = "FFFFFF",
	white38 = "FFFFFF",
	white30 = "FFFFFF",
	white24 = "FFFFFF",
	white12 = "FFFFFF",
	white10 = "FFFFFF",
}

local COLORS = {}

local function words(s)
	local t = {}
	for w in s:gmatch("%x+") do
		t[#t + 1] = w
	end
	return t
end

for name, list in pairs(SWATCHES) do
	local hexes, shades = words(list), {}
	for i, shade in ipairs(SHADES) do
		shades[shade] = hexes[i]
	end
	COLORS[name] = { shades = shades, base = 500 }
end
COLORS.grey.shades[350] = "D6D6D6"
COLORS.grey.shades[850] = "303030"

for name, list in pairs(ACCENTS) do
	local hexes, shades = words(list), {}
	for i, shade in ipairs(ACCENT_SHADES) do
		shades[shade] = hexes[i]
	end
	COLORS[name .. "Accent"] = { shades = shades, base = 200 }
end

for name, hex in pairs(SINGLES) do
	COLORS[name] = { shades = {}, single = hex }
end

function M.find(line)
	local out = {}
	if not line:find("Colors.", 1, true) then
		return out
	end
	local init = 1
	while true do
		local s, e, name = line:find("Colors%.(%a[%w]*)", init)
		if not s then
			break
		end
		init = e + 1
		local prev = s > 1 and line:sub(s - 1, s - 1) or ""
		local entry = COLORS[name]
		if entry and not prev:match("[%w_]") then
			local rest = line:sub(e + 1)
			local idx, len = rest:match("^%[(%d+)%]"), nil
			if idx then
				len = #idx + 2
			else
				idx = rest:match("^%.shade(%d+)")
				if idx then
					len = #idx + 6
				end
			end
			local hex
			if idx then
				hex = entry.shades[tonumber(idx)]
			else
				hex = entry.single or entry.shades[entry.base]
			end
			if hex then
				out[#out + 1] = { s = s - 1, e = e + (idx and len or 0), hex = hex }
			end
		end
	end
	return out
end

local ns = vim.api.nvim_create_namespace("flutter_colors")
local groups = {}

local function group_for(hex)
	if not groups[hex] then
		local r = tonumber(hex:sub(1, 2), 16)
		local g = tonumber(hex:sub(3, 4), 16)
		local b = tonumber(hex:sub(5, 6), 16)
		local bright = (0.299 * r + 0.587 * g + 0.114 * b) / 255 > 0.5
		local name = "FlutterColor" .. hex
		vim.api.nvim_set_hl(0, name, { bg = "#" .. hex, fg = bright and "#000000" or "#ffffff" })
		groups[hex] = name
	end
	return groups[hex]
end

local function scan(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		for _, m in ipairs(M.find(line)) do
			vim.api.nvim_buf_set_extmark(buf, ns, row - 1, m.s, {
				end_col = m.e,
				hl_group = group_for(m.hex),
				priority = 200,
			})
		end
	end
end

local pending = {}

local function schedule(buf)
	if pending[buf] then
		return
	end
	pending[buf] = true
	vim.defer_fn(function()
		pending[buf] = nil
		scan(buf)
	end, 100)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("flutter_colors", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "InsertLeave" }, {
		group = group,
		pattern = "*.dart",
		callback = function(ev)
			schedule(ev.buf)
		end,
	})
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			groups = {}
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.bo[buf].filetype == "dart" then
					schedule(buf)
				end
			end
		end,
	})
end

return M
