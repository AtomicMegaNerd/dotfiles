--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
-- Custom Neovim keybindings

local keymap = vim.keymap

-- Arrow keys
----------------------------------------------------------------
-- Disable arrow keys for editing
keymap.set("n", "<up>", "<nop>")
keymap.set("n", "<down>", "<nop>")
keymap.set("i", "<up>", "<nop>")
keymap.set("i", "<down>", "<nop>")
keymap.set("i", "<left>", "<nop>")
keymap.set("i", "<right>", "<nop>")

-- Left and right can switch buffers
keymap.set("n", "<left>", "<cmd>bp<cr>")
keymap.set("n", "<right>", "<cmd>bn<cr>")

-- Delete without overwriting the clipboard
keymap.set("n", "x", '"_x')

-- Telescope keybindings
----------------------------------------------------------------

local ts_status, ts = pcall(require, "telescope")
if not ts_status then
	return
end

local tb_status, tb = pcall(require, "telescope.builtin")
if not tb_status then
	return
end
local tfb = ts.extensions.file_browser.file_browser

local nt_status, nt = pcall(require, "neotest")
if not nt_status then
	return
end

-- Telescope basics
keymap.set("n", "<leader>ff", tb.find_files, { desc = "[F]ind [F]files" })
keymap.set("n", "<leader>fb", tb.buffers, { desc = "[F]ind [B]uffers" })
keymap.set("n", "<leader>fd", tb.diagnostics, { desc = "[F]ind [D]iagnostics" })
keymap.set("n", "<leader>fl", tb.live_grep, { desc = "[F]ind [L]ive [G]rep" })
-- Git
keymap.set("n", "<leader>fg", tb.git_files, { desc = "[F]ind [G]it files" })
keymap.set("n", "<leader>fr", tb.git_branches, { desc = "[F]ind Git B[R]anch" })
keymap.set("n", "<leader>fc", tb.git_commits, { desc = "[F]ind Git [C]ommits" })
keymap.set("n", "<leader>fs", tb.git_status, { desc = "[F]ind Git [S]tatus" })
-- Neovim
keymap.set("n", "<leader>fh", tb.help_tags, { desc = "[F]ind Neovim [H]elp topics" })
keymap.set("n", "<leader>fm", tb.commands, { desc = "[F]ind Neovim Co[M]mands" })
keymap.set("n", "<leader>fk", tb.keymaps, { desc = "[F]ind Neovim [K]eymaps" })
-- Todo Comments
keymap.set("n", "<leader>ft", [[<cmd>TodoTelescope<cr>]], { desc = "[F]ind [T]odo Comments" })
-- File Browser
keymap.set("n", "<leader>bf", tfb, { desc = "[B]rowse [F]iles " })
-- ToggleTerm
keymap.set("n", "<leader>c", [[<cmd>ToggleTerm direction=float<cr>]], { desc = "Open [C]ommand-line terminal" })

-- Refactoring
----------------------------------------------------------------
vim.api.nvim_set_keymap(
	"v",
	"<leader>re",
	[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
	{ noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>rf",
	[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
	{ noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>rv",
	[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
	{ noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>ri",
	[[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
	{ noremap = true, silent = true, expr = false }
)

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap(
	"n",
	"<leader>rb",
	[[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
	{ noremap = true, silent = true, expr = false }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>rbf",
	[[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
	{ noremap = true, silent = true, expr = false }
)

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap(
	"n",
	"<leader>ri",
	[[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
	{ noremap = true, silent = true, expr = false }
)

-- Run Tests
----------------------------------------------------------------
keymap.set("n", "<leader>tn", function()
	nt.run.run()
	nt.output.open()
end, { desc = "Run [T]est [N]earest to cursor" })

keymap.set("n", "<leader>tf", function()
	nt.run.run(vim.fn.expand("%"))
	nt.output.open()
end, { desc = "Run all [T]ests in [F]ile" })

keymap.set("n", "<leader>ts", function()
	nt.run.run(vim.fn.getcwd())
	nt.summary.open()
end, { desc = "Run whole [T]est [S]uite" })
