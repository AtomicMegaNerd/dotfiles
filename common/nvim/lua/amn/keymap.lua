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
	vim.print("Error: could not load telescope")
	return
end

local tb_status, tb = pcall(require, "telescope.builtin")
if not tb_status then
	vim.print("Error: could not load telescope.builtin")
	return
end

local tfb = ts.extensions.file_browser.file_browser

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

-- Run Tests
----------------------------------------------------------------
keymap.set("n", "<leader>tn", [[<cmd>TestNearest<cr>]], { desc = "Run [T]est [N]earest to cursor" })
keymap.set("n", "<leader>tf", [[<cmd>TestFile<cr>]], { desc = "Run all [T]ests in [F]ile" })
keymap.set("n", "<leader>ts", [[<cmd>TestSuite<cr>]], { desc = "Run whole [T]est [S]uite" })
keymap.set("n", "<leader>tv", [[<cmd>TestVisit<cr>]], { desc = "Return to the last [T]est file and [V]isit" })
