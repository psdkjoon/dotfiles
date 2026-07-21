---@diagnostic disable: undefined-global
local opt = vim.opt
local api = vim.api
local key = vim.keymap

opt.whichwrap:append("<,>,[,]")
opt.foldmethod = "syntax"
opt.foldenable = true
opt.foldlevel = 99
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 1000

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("WQA", "wqa", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("QA", "qa", {})

local function run(flags)
	flags = " " .. (flags or "")
	vim.cmd("silent! write")
	local file = vim.fn.expand("%:p")
	local ft = vim.bo.filetype
	local cmd = ""
	if ft == "dart" then
		cmd = "dart run " .. vim.fn.shellescape(file)
	elseif ft == "python" then
		cmd = "python3 " .. vim.fn.shellescape(file)
	elseif ft == "sh" or ft == "bash" then
		cmd = "bash " .. vim.fn.shellescape(file)
	elseif ft == "lua" then
		cmd = "lua " .. vim.fn.shellescape(file)
	elseif ft == "go" then
		cmd = "go run " .. vim.fn.shellescape(file)
	elseif ft == "rust" then
		cmd = "rustc " .. vim.fn.shellescape(file) .. " -o /tmp/nvimrun && /tmp/nvimrun"
	elseif ft == "cpp" then
		cmd = "g++ " .. vim.fn.shellescape(file) .. " -o /tmp/nvimrun && /tmp/nvimrun"
	elseif ft == "c" then
		cmd = "gcc " .. vim.fn.shellescape(file) .. " -o /tmp/nvimrun && /tmp/nvimrun"
	elseif ft == "cs" then
		cmd = "dotnet run " .. vim.fn.shellescape(file)
	else
		if string.match(vim.fn.getline(1), "^#!") then
			cmd = vim.fn.shellescape(file)
		else
			vim.notify("No runner for: " .. ft, vim.log.levels.WARN)
			return
		end
	end
	vim.cmd("vsplit | terminal " .. cmd .. flags)
	vim.cmd("startinsert")
end

key.set({ "n", "i", "v" }, "<F2>", function()
	run()
end, { desc = "Run file" })
key.set({ "n", "i", "v" }, "<F3>", function()
	vim.ui.input({ prompt = "Flags: " }, function(input)
		run(input)
	end)
end, { desc = "Run file with flags" })

api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = api.nvim_buf_get_mark(0, '"')
		local lcount = api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
