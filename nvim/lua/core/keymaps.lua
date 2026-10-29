local M = {}

local runner = require("core.runner")
local keymap = vim.keymap
local ui = vim.ui
local lsp = vim.lsp
local diag = vim.diagnostic
local api = vim.api

keymap.set({ "n", "i", "v" }, "<F2>", function()
	runner.run()
end, { desc = "Run file / project" })

keymap.set({ "n", "i", "v" }, "<F3>", function()
	ui.input({ prompt = "Flags: " }, function(input)
		if input ~= nil then
			runner.run(input)
		end
	end)
end, { desc = "Run file / project with flags" })

keymap.set({ "n", "i", "v" }, "<F4>", function()
	runner.stop()
end, { desc = "Stop running job" })

keymap.set({ "n", "i", "v" }, "<leader>rt", function()
	runner.toggle_window()
end, { desc = "Toggle runner terminal window" })

keymap.set("n", "<leader>gd", function()
	require("telescope.builtin").diagnostics()
end, { desc = "Diagnostics" })

keymap.set("n", "<leader>gc", function()
	require("telescope.builtin").live_grep({ default_text = "-- \\|// \\|# " })
end, { desc = "Find Comments" })

keymap.set("n", "<leader>gf", function()
	require("telescope.builtin").find_files()
end, { desc = "Find Files" })

keymap.set("n", "<leader>gi", function()
	require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find Files (hidden)" })

keymap.set("n", "<leader>gh", function()
	require("telescope.builtin").git_bcommits()
end, { desc = "File history (Telescope)" })

keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Move to window left" })
keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Move to window below" })
keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Move to window above" })
keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Move to window right" })

keymap.set("v", "<C-Left>", "<C-w>h", { desc = "Move to window left" })
keymap.set("v", "<C-Down>", "<C-w>j", { desc = "Move to window below" })
keymap.set("v", "<C-Up>", "<C-w>k", { desc = "Move to window above" })
keymap.set("v", "<C-Right>", "<C-w>l", { desc = "Move to window right" })

keymap.set("i", "<C-Left>", "<Esc><C-w>hi", { desc = "Move to window left" })
keymap.set("i", "<C-Down>", "<Esc><C-w>ji", { desc = "Move to window below" })
keymap.set("i", "<C-Up>", "<Esc><C-w>ki", { desc = "Move to window above" })
keymap.set("i", "<C-Right>", "<Esc><C-w>li", { desc = "Move to window right" })

keymap.set("n", "<C-n>", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })

function M.nvim_tree_on_attach(bufnr)
	local tapi = require("nvim-tree.api")
	tapi.config.mappings.default_on_attach(bufnr)
	local function opts(desc)
		return { desc = "NvimTree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	keymap.set("n", "a", tapi.fs.create, opts("Create file/folder"))
	keymap.set("n", "r", tapi.fs.rename, opts("Rename"))
	keymap.set("n", "<CR>", tapi.node.open.edit, opts("Open file/folder"))
	keymap.set("n", "<Right>", tapi.node.open.edit, opts("Expand folder / open file"))
	keymap.set("n", "<Left>", tapi.node.navigate.parent_close, opts("Collapse folder / go to parent"))
end

api.nvim_create_autocmd("FileType", {
	pattern = "dart",
	group = api.nvim_create_augroup("flutter_keymaps", { clear = true }),
	callback = function(ev)
		local fopts = { buffer = ev.buf }

		keymap.set("n", "<F5>", "<cmd>FlutterRun<CR>", vim.tbl_extend("force", fopts, { desc = "Flutter Run" }))
		keymap.set("n", "<F6>", "<cmd>FlutterRestart<CR>", vim.tbl_extend("force", fopts, { desc = "Flutter Restart" }))
		keymap.set(
			"n",
			"<F7>",
			"<cmd>FlutterReload<CR>",
			vim.tbl_extend("force", fopts, { desc = "Flutter Hot Reload" })
		)

		keymap.set("n", "<F8>", "<cmd>FlutterQuit<CR>", vim.tbl_extend("force", fopts, { desc = "Flutter Quit" }))
		keymap.set(
			"n",
			"<leader>fd",
			"<cmd>FlutterDevices<CR>",
			vim.tbl_extend("force", fopts, { desc = "Flutter Devices" })
		)
		keymap.set(
			"n",
			"<leader>fe",
			"<cmd>FlutterEmulators<CR>",
			vim.tbl_extend("force", fopts, { desc = "Flutter Emulators" })
		)
		keymap.set(
			"n",
			"<leader>fo",
			"<cmd>FlutterOutlineToggle<CR>",
			vim.tbl_extend("force", fopts, { desc = "Flutter Outline" })
		)
		keymap.set(
			"n",
			"<leader>fp",
			"<cmd>FlutterPubGet<CR>",
			vim.tbl_extend("force", fopts, { desc = "Flutter Pub Get" })
		)
		keymap.set(
			"n",
			"<leader>fv",
			"<cmd>FlutterDevTools<CR>",
			vim.tbl_extend("force", fopts, { desc = "Flutter DevTools" })
		)

		local function dmap(lhs, rhs, desc)
			keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		dmap("<leader>dc", "<cmd>DartDataClass<CR>", "Dart: data class (ctor/copyWith/==/toString)")
		dmap("<leader>dC", "<cmd>DartDataClass all<CR>", "Dart: data class + toMap/fromMap/json")
		dmap("<leader>ip", "<cmd>DartImagePreview<CR>", "Dart: preview image asset on line")
		dmap("<leader>pa", function()
			ui.input({ prompt = "pub add: " }, function(input)
				if input and input ~= "" then
					vim.cmd("PubAdd " .. input)
				end
			end)
		end, "Pub: add package")
		dmap("<leader>pd", function()
			ui.input({ prompt = "pub add --dev: " }, function(input)
				if input and input ~= "" then
					vim.cmd("PubAddDev " .. input)
				end
			end)
		end, "Pub: add dev package")
	end,
})

keymap.set("n", "gl", diag.open_float, { desc = "Open diagnostics floating" })
keymap.set("n", "gd", lsp.buf.definition, { desc = "Go to Definition" })
keymap.set({ "n", "v", "i" }, "<C-.>", lsp.buf.code_action, { desc = "LSP Code Actions (Quick Fix)" })
keymap.set("n", "K", function()
	lsp.buf.hover({ border = "rounded" })
end, { desc = "Show Hover Documentation" })
api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = api.nvim_create_augroup("float_diagnostic", { clear = true }),
	callback = function()
		diag.open_float(nil, { focus = false, border = "rounded", scope = "cursor" })
	end,
})

keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
keymap.set("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })

keymap.set({ "n", "x" }, "<leader>ca", lsp.buf.code_action, { desc = "Code action / quick fix" })
keymap.set({ "n", "x" }, "<leader>cr", function()
	lsp.buf.code_action({ context = { only = { "refactor" } } })
end, { desc = "Refactor (extract widget/method/variable, wrap with widget...)" })
keymap.set("n", "<leader>rn", lsp.buf.rename, { desc = "Rename symbol (updates imports)" })
keymap.set("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
keymap.set("n", "<leader>cx", function()
	require("core.dart.fix").code_action_sync(0, "source.fixAll", 3000)
end, { desc = "Fix all auto-fixable (const, unused imports...)" })
keymap.set("n", "<leader>co", function()
	require("core.dart.fix").code_action_sync(0, "source.organizeImports", 3000)
end, { desc = "Organize imports" })
keymap.set("n", "gr", function()
	require("telescope.builtin").lsp_references()
end, { desc = "References" })
keymap.set("n", "gi", function()
	require("telescope.builtin").lsp_implementations()
end, { desc = "Implementations" })
keymap.set("n", "<leader>ss", function()
	require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document symbols" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left, keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right, keep selection" })

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

return M
