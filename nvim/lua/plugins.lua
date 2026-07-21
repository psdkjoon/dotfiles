---@diagnostic disable: undefined-global
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				integrations = {
					mason = true,
					nvimtree = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "│" },
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({ options = { sections = { lualine_x = { "fileformat", "filetype" } } } })
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				user_default_options = { css = true, names = false, mode = "background" },
			})
		end,
	},
	{ "tpope/vim-sleuth" },
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = { "python", "cpp", "bash", "lua", "html", "css", "javascript", "json" },
				highlight = { enable = true },
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			vim.notify = notify
			notify.setup({
				background_colour = "#000000",
				fps = 60,
				render = "default",
				timeout = 3000,
				top_down = false,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = {
					["<Down>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Up>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end, { "i", "s" }),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-Space>"] = cmp.mapping.complete(),
				},
				formatting = {
					format = function(entry, vim_item)
						if entry.source.name == "nvim_lsp" and vim_item.kind == "Text" then
							return nil
						end
						return vim_item
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{
						name = "path",
						priority = 500,
						option = {
							get_bufnrs = function()
								return {}
							end,
							trigger_characters = { "/", "./", "../" },
						},
					},
				}),
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local tools = {
				servers = { "pyright", "clangd", "bashls", "lua_ls", "html", "cssls", "ts_ls", "jsonls", "dartls" },
				all = {
					"tree-sitter-cli",
					"dcm",
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
			vim.diagnostic.config({
				update_in_insert = true,
				severity_sort = true,
				float = { border = "rounded" },
			})
			vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open diagnostics floating" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
			vim.keymap.set({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, { desc = "LSP Code Actions (Quick Fix)" })
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover({ border = "rounded" })
			end, { desc = "Show Hover Documentation" })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
				callback = function()
					vim.diagnostic.open_float(nil, { focus = false, border = "rounded", scope = "cursor" })
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "black" },
					cpp = { "clang-format" },
					bash = { "shfmt" },
					lua = { "stylua" },
					javascript = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					json = { "prettier" },
					dart = { "dart_format" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}
