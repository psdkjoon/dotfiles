local M = {}

local uv = vim.uv or vim.loop

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "Dart" })
end

local function project_root()
	return vim.fs.root(0, "pubspec.yaml") or vim.fs.root(uv.cwd() or ".", "pubspec.yaml")
end

local function is_flutter(root)
	local ok, lines = pcall(vim.fn.readfile, root .. "/pubspec.yaml")
	if not ok then
		return false
	end
	for _, l in ipairs(lines) do
		if l:match("^%s+sdk:%s*flutter%s*$") then
			return true
		end
	end
	return false
end

local function run(cmd, root)
	if vim.fn.executable(cmd[1]) == 0 then
		return notify("`" .. cmd[1] .. "` not found in PATH", vim.log.levels.ERROR)
	end
	notify(table.concat(cmd, " ") .. " ...")
	vim.system(
		cmd,
		{ cwd = root, text = true },
		vim.schedule_wrap(function(res)
			local out = vim.trim((res.stdout or "") .. (res.stderr or ""))
			local lines = vim.split(out, "\n", { plain = true })
			local tail = table.concat(vim.list_slice(lines, math.max(1, #lines - 9), #lines), "\n")
			notify(tail ~= "" and tail or "done", res.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
			vim.cmd("checktime")
		end)
	)
end

local function pub(args)
	local root = project_root()
	if not root then
		return notify("No pubspec.yaml found above this file", vim.log.levels.WARN)
	end
	local cmd = { is_flutter(root) and "flutter" or "dart", "pub" }
	vim.list_extend(cmd, args)
	run(cmd, root)
end

function M.preview_image()
	local exts = { png = 1, jpg = 1, jpeg = 1, gif = 1, webp = 1, bmp = 1, svg = 1, ico = 1 }
	local line = vim.api.nvim_get_current_line()
	local candidates = {}
	for s in line:gmatch("[\"']([^\"']+)[\"']") do
		candidates[#candidates + 1] = s
	end
	for s in line:gmatch("[%w_%-%./]+") do
		candidates[#candidates + 1] = s
	end

	local root = project_root() or uv.cwd()
	local here = vim.fn.expand("%:p:h")
	for _, s in ipairs(candidates) do
		local ext = s:match("%.(%w+)$")
		if ext and exts[ext:lower()] then
			for _, base in ipairs({ root, here }) do
				local path = base .. "/" .. s
				if uv.fs_stat(path) then
					local _, err = vim.ui.open(path)
					if err then
						notify(err, vim.log.levels.ERROR)
					end
					return
				end
			end
		end
	end
	notify("No existing image path found on this line", vim.log.levels.WARN)
end

function M.setup()
	local cmd = vim.api.nvim_create_user_command

	cmd("DartDataClass", function(o)
		local mode = o.args ~= "" and o.args or "basic"
		if mode ~= "basic" and mode ~= "all" then
			return notify("Usage: :DartDataClass [basic|all]", vim.log.levels.WARN)
		end
		require("core.dart.dataclass").generate(mode)
	end, {
		nargs = "?",
		complete = function()
			return { "basic", "all" }
		end,
		desc = "Generate constructor/copyWith/==/hashCode/toString (all: + toMap/fromMap/json)",
	})

	cmd("PubAdd", function(o)
		pub(vim.list_extend({ "add" }, o.fargs))
	end, { nargs = "+", desc = "pub add <package>..." })

	cmd("PubAddDev", function(o)
		pub(vim.list_extend({ "add", "--dev" }, o.fargs))
	end, { nargs = "+", desc = "pub add --dev <package>..." })

	cmd("PubRemove", function(o)
		pub(vim.list_extend({ "remove" }, o.fargs))
	end, { nargs = "+", desc = "pub remove <package>..." })

	cmd("PubGet", function()
		pub({ "get" })
	end, { desc = "pub get" })

	cmd("PubUpgrade", function()
		pub({ "upgrade" })
	end, { desc = "pub upgrade" })

	cmd("DartImagePreview", M.preview_image, { desc = "Open the image asset on this line" })
end

return M
