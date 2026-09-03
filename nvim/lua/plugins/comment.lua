return {
	"numToStr/Comment.nvim",
	opts = {},
	keys = {
		{
			"<C-_>",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			mode = "n",
			desc = "Comment line",
		},
		{
			"<C-_>",
			function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
				require("Comment.api").toggle.linewise(vim.fn.line("'<"), vim.fn.line("'>"))
			end,
			mode = "v",
			desc = "Comment selection",
		},
	},
}
