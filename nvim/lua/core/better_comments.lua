local M = {}

local TAGS = {
	["!"] = "BetterCommentAlert",
	["?"] = "BetterCommentQuery",
	["*"] = "BetterCommentImportant",
}

function M.find_tag(line, prefix)
	local pat = vim.pesc and vim.pesc(prefix) or prefix:gsub("%p", "%%%0")
	local init = 1
	while true do
		local a, _, tag = line:find(pat .. "%s*([!?*])", init)
		if not a then
			return nil
		end
		local prev = a > 1 and line:sub(a - 1, a - 1) or ""
		if prev ~= ":" and prev ~= prefix:sub(1, 1) then
			return a - 1, tag
		end
		init = a + 1
	end
end

local function set_highlights()
	local set = vim.api.nvim_set_hl
	set(0, "BetterCommentAlert", { fg = "#f38ba8", bold = true })
	set(0, "BetterCommentQuery", { fg = "#89b4fa", bold = true })
	set(0, "BetterCommentImportant", { fg = "#a6e3a1", bold = true })
end

function M.setup()
	set_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("better_comments_hl", { clear = true }),
		callback = set_highlights,
	})

	local ns = vim.api.nvim_create_namespace("better_comments")
	local prefix

	vim.api.nvim_set_decoration_provider(ns, {
		on_win = function(_, _, bufnr)
			if vim.bo[bufnr].buftype ~= "" then
				return false
			end
			prefix = (vim.bo[bufnr].commentstring or ""):match("^(.-)%s*%%s")
			return prefix ~= nil and prefix ~= ""
		end,
		on_line = function(_, _, bufnr, row)
			pcall(function()
				local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
				if not line then
					return
				end
				local col, tag = M.find_tag(line, prefix)
				if col then
					vim.api.nvim_buf_set_extmark(bufnr, ns, row, col, {
						end_row = row,
						end_col = #line,
						hl_group = TAGS[tag],
						ephemeral = true,
						priority = 300,
					})
				end
			end)
		end,
	})
end

return M
