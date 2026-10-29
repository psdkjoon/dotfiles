local M = {}

function M.code_action_sync(bufnr, kind, timeout_ms)
	bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
	timeout_ms = timeout_ms or 1500
	local applied = false

	local last = vim.api.nvim_buf_line_count(bufnr)
	local last_len = #(vim.api.nvim_buf_get_lines(bufnr, last - 1, last, false)[1] or "")

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })) do
		local params = vim.lsp.util.make_given_range_params({ 1, 0 }, { last, last_len }, bufnr, client.offset_encoding)
		params.context = { only = { kind }, diagnostics = {} }

		local res = client:request_sync("textDocument/codeAction", params, timeout_ms, bufnr)
		if res and res.result then
			for _, action in ipairs(res.result) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
					applied = true
				end
			end
		end
	end
	return applied
end

function M.on_save(bufnr)
	if vim.api.nvim_buf_line_count(bufnr) > 4000 then
		return
	end
	if vim.g.autosave_event ~= nil and #vim.diagnostic.get(bufnr) == 0 then
		return
	end
	pcall(M.code_action_sync, bufnr, "source.fixAll", 1500)
end

return M
