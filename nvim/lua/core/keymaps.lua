local runner = require("core.runner")
local keymap = vim.keymap
local ui = vim.ui

keymap.set("n", "<F2>", function()
	runner.run()
end, { desc = "Run file / project" })

keymap.set("n", "<F3>", function()
	ui.input({ prompt = "Flags: " }, function(input)
		if input ~= nil then
			runner.run(input)
		end
	end)
end, { desc = "Run file / project with flags" })

keymap.set("n", "<F4>", function()
	runner.stop()
end, { desc = "Stop running job" })

keymap.set("n", "<leader>rt", function()
	runner.toggle_window()
end, { desc = "Toggle runner terminal window" })

keymap.set("n", "<leader>fd", function()
	require("telescope.builtin").diagnostics()
end, { desc = "Diagnostics" })

keymap.set("n", "<leader>fc", function()
	require("telescope.builtin").live_grep({ default_text = "-- \\|// \\|# " })
end, { desc = "Find Comments" })

keymap.set("n", "<leader>ffn", function()
	require("telescope.builtin").treesitter({ symbols = { "function" } })
end, { desc = "Find Functions" })

keymap.set("n", "<leader>fmt", function()
	require("telescope.builtin").treesitter({ symbols = { "method" } })
end, { desc = "Find Methods" })

keymap.set("n", "<leader>fcl", function()
	require("telescope.builtin").treesitter({ symbols = { "class" } })
end, { desc = "Find Classes" })

keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find Files" })

keymap.set("n", "<leader>fh", function()
	require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find Files (hidden)" })
