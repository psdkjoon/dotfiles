return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				python = { "black" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				bash = { "shfmt" },
				lua = { "stylua" },
				javascript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				rust = { "rustfmt" },
				dart = { "dart_format", lsp_format = "prefer" },
			},
			default_format_opts = { lsp_format = "fallback", timeout_ms = 2000 },
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
			callback = function(ev)
				local buf = ev.buf
				if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
					return
				end
				if vim.bo[buf].buftype ~= "" then
					return
				end

				if vim.bo[buf].filetype == "dart" and not vim.g.disable_autofix then
					require("core.dart.fix").on_save(buf)
				end

				conform.format({
					bufnr = buf,
					timeout_ms = 2000,
					lsp_format = "fallback",
					quiet = vim.g.autosave_event ~= nil,
				})
			end,
		})

		vim.api.nvim_create_user_command("FormatToggle", function()
			vim.g.disable_autoformat = not vim.g.disable_autoformat
			vim.notify("Format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
		end, { desc = "Toggle format on save" })

		vim.api.nvim_create_user_command("FixToggle", function()
			vim.g.disable_autofix = not vim.g.disable_autofix
			vim.notify("Dart auto-fix (const etc.) on save: " .. (vim.g.disable_autofix and "OFF" or "ON"))
		end, { desc = "Toggle Dart fixAll on save" })
	end,
}
