return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("nvim-tree").setup({
			view = {
				width = 32,
				side = "left",
			},
			renderer = {
				group_empty = true,
				highlight_git = true,
				icons = {
					show = {
						git = true,
						folder = true,
						file = true,
						folder_arrow = true,
					},
					glyphs = {
						git = {
							unstaged = "✗",
							staged = "✓",
							unmerged = "",
							renamed = "➜",
							untracked = "★",
							deleted = "",
							ignored = "◌",
						},
					},
				},
			},
			git = {
				enable = true,
				ignore = false,
				timeout = 400,
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
			},
			filters = {
				dotfiles = false,
				custom = { "^.git$" },
			},
			actions = {
				open_file = {
					quit_on_open = false,
					resize_window = true,
				},
			},
			update_focused_file = {
				enable = true,
			},
			on_attach = function() end,
		})

		local min_width = 100
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.o.columns >= min_width then
					local cur_win = vim.api.nvim_get_current_win()
					require("nvim-tree.api").tree.open()
					vim.api.nvim_set_current_win(cur_win)
				end
			end,
		})
	end,
}
