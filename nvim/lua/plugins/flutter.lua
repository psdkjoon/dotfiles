return {
	"nvim-flutter/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{
			"stevearc/dressing.nvim",
			opts = {
				select = {
					backend = { "telescope", "builtin" },
				},
			},
		},
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		require("flutter-tools").setup({
			ui = {
				border = "rounded",
				notification_style = "native",
			},
			decorations = {
				statusline = {
					app_version = false,
					device = true,
				},
			},
			widget_guides = { enabled = true },
			dev_log = {
				open_cmd = "rightbelow 5vnew",
			},
			outline = {
				open_cmd = "rightbelow 5vnew",
			},
			closing_tags = {
				highlight = "Comment",
				prefix = "// ",
				enabled = true,
			},
			lsp = {
				capabilities = capabilities,
				settings = {
					showTodos = false,
					completeFunctionCalls = true,
					enableSnippets = true,
					updateImportsOnRename = true,
					renameFilesWithClasses = "prompt",
					analysisExcludedFolders = { vim.fn.expand("~/.pub-cache") },
				},
			},
		})

		local ok, flutter_log = pcall(require, "flutter-tools.log")
		if ok and type(flutter_log.log) == "function" then
			local original = flutter_log.log
			flutter_log.log = function(...)
				pcall(original, ...)
			end
		end
	end,
}
