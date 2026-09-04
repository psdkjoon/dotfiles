local opt = vim.opt
local api = vim.api

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
opt.hlsearch = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 300
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.mouse = "a"
opt.undofile = true
opt.confirm = true

api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = api.nvim_buf_get_mark(0, '"')
		local lcount = api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Autosave: write the buffer after edits / when leaving it, if it's a real,
-- modifiable, named file.
api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, {
	group = api.nvim_create_augroup("autosave", { clear = true }),
	callback = function(ev)
		local buf = ev.buf
		if
			vim.bo[buf].modifiable
			and not vim.bo[buf].readonly
			and vim.bo[buf].buftype == ""
			and vim.api.nvim_buf_get_name(buf) ~= ""
			and vim.bo[buf].modified
		then
			vim.api.nvim_buf_call(buf, function()
				vim.cmd("silent! write")
			end)
		end
	end,
})
