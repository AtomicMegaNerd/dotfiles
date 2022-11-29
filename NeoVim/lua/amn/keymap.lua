--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
-- Custom Neovim keybindings

-- Arrow keys
----------------------------------------------------------------
-- Disable arrow keys for editing
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")

-- Left and right can switch buffers
vim.keymap.set("n", "<left>", "<cmd>bp<cr>")
vim.keymap.set("n", "<right>", "<cmd>bn<cr>")

-- Delete without overwriting the clipboard
vim.keymap.set("n", "x", '"_x')

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

-- Telescope basics
vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "[F]ind [F]files" })
vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>fd", tb.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fl", tb.live_grep, { desc = "[F]ind [L]ive [G]rep" })
-- Git
vim.keymap.set("n", "<leader>fg", tb.git_files, { desc = "[F]ind [G]it files" })
vim.keymap.set("n", "<leader>fr", tb.git_branches, { desc = "[F]ind Git B[R]anch" })
vim.keymap.set("n", "<leader>fc", tb.git_commits, { desc = "[F]ind Git [C]ommits" })
vim.keymap.set("n", "<leader>fs", tb.git_status, { desc = "[F]ind Git [S]tatus" })
-- Neovim
vim.keymap.set("n", "<leader>fh", tb.help_tags, { desc = "[F]ind Neovim [H]elp topics" })
vim.keymap.set("n", "<leader>fm", tb.commands, { desc = "[F]ind Neovim Co[M]mands" })
vim.keymap.set("n", "<leader>fk", tb.keymaps, { desc = "[F]ind Neovim [K]eymaps" })
-- Todo Comments
vim.keymap.set("n", "<leader>ft", [[<cmd>TodoTelescope<cr>]], { desc = "[F]ind [T]odo Comments" })
-- File Browser
vim.keymap.set("n", "<leader>bf", tfb, { desc = "[B]rowse [F]iles " })

-- VimTest
----------------------------------------------------------------
vim.keymap.set("n", "<leader>tn", [[<cmd>TestNearest<cr>]], { desc = "Run [T]est [N]earest to cursor" })
vim.keymap.set("n", "<leader>tf", [[<cmd>TestFile<cr>]], { desc = "Run all [T]ests in [F]ile" })
vim.keymap.set("n", "<leader>ts", [[<cmd>TestSuite<cr>]], { desc = "Run whole [T]est [S]uite" })
vim.keymap.set("n", "<leader>tl", [[<cmd>TestLast<cr>]], { desc = "Re-Run [T]est we ran [L]ast" })
vim.keymap.set("n", "<leader>tv", [[<cmd>TestVisit<cr>]], { desc = "Return to the last [T]est file and [V]isit" })
