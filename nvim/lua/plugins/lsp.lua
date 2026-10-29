return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local tools = {
				servers = {
					"pyright",
					"clangd",
					"bashls",
					"lua_ls",
					"html",
					"cssls",
					"ts_ls",
					"jsonls",
					"rust_analyzer",
					"gh_actions_ls",
				},
				all = {
					"tree-sitter-cli",
					"black",
					"clang-format",
					"shfmt",
					"stylua",
					"prettier",
					"pyright",
					"clangd",
					"bashls",
					"lua_ls",
					"html",
					"cssls",
					"ts_ls",
					"jsonls",
					"rust_analyzer",
					"gh_actions_ls",
				},
			}
			require("mason").setup({ ui = { border = "rounded" } })
			require("mason-tool-installer").setup({
				ensure_installed = tools.all,
				auto_update = true,
			})
			require("mason-lspconfig").setup({
				automatic_enable = false,
			})
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			for _, server in ipairs(tools.servers) do
				vim.lsp.config(server, {
					capabilities = capabilities,
				})
				vim.lsp.enable(server)
			end
			local sev = vim.diagnostic.severity
			local function icon(codepoint)
				return vim.fn.nr2char(codepoint)
			end
			vim.diagnostic.config({
				update_in_insert = true,
				severity_sort = true,
				float = { border = "rounded" },
				virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
				signs = {
					text = {
						[sev.ERROR] = icon(0xF015A),
						[sev.WARN] = icon(0xF002A),
						[sev.INFO] = icon(0xF02FD),
						[sev.HINT] = icon(0xF0336),
					},
					linehl = {
						[sev.ERROR] = "DiagnosticLineError",
						[sev.WARN] = "DiagnosticLineWarn",
						[sev.INFO] = "DiagnosticLineInfo",
						[sev.HINT] = "DiagnosticLineHint",
					},
				},
			})

			local function error_lens_highlights()
				local set = vim.api.nvim_set_hl
				set(0, "DiagnosticLineError", { bg = "#33232c" })
				set(0, "DiagnosticLineWarn", { bg = "#33302a" })
				set(0, "DiagnosticLineInfo", { bg = "#232d38" })
				set(0, "DiagnosticLineHint", { bg = "#232f33" })
				set(0, "DiagnosticVirtualTextError", { fg = "#f38ba8", bg = "#3b2731" })
				set(0, "DiagnosticVirtualTextWarn", { fg = "#f9e2af", bg = "#3a352b" })
				set(0, "DiagnosticVirtualTextInfo", { fg = "#89b4fa", bg = "#28344a" })
				set(0, "DiagnosticVirtualTextHint", { fg = "#94e2d5", bg = "#283a3c" })
			end
			error_lens_highlights()
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("error_lens_hl", { clear = true }),
				callback = error_lens_highlights,
			})
		end,
	},
}
