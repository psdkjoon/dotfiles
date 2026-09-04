return {
	"numToStr/Comment.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {},
	keys = {
		{
			"<leader>/",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			mode = "n",
			desc = "Comment line",
		},
		{
			"<leader>/",
			function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
				require("Comment.api").toggle.linewise(vim.fn.line("'<"), vim.fn.line("'>"))
			end,
			mode = "v",
			desc = "Comment selection",
		},
	},
}
