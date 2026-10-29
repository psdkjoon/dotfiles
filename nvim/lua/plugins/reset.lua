return {
	"ryoppippi/nvim-reset",
	opts = {
		ignore_maps = {
			{ mode = { "n", "x", "v" }, lhs = "gc" },
			{ mode = "n", lhs = "gcc" },
			{ mode = "n", lhs = "gco" },
			{ mode = "n", lhs = "gcO" },
			{ mode = "o", lhs = "gc" },
		},
	},
}
