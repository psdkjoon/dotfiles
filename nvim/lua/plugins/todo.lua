return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		signs = false,
		highlight = {
			comments_only = false,
		},
	},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
		{ "<leader>tt", "<cmd>TodoTelescope<CR>", desc = "Todo tree (Telescope)" },
		{ "<leader>tq", "<cmd>TodoQuickFix<CR>", desc = "Todo tree (quickfix)" },
	},
}
