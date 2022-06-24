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

-- Telescope keybindings
----------------------------------------------------------------
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]files" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>flg", require("telescope.builtin").live_grep, { desc = "[F]ind [L]ive [G]rep" })
-- Git
vim.keymap.set("n", "<leader>fgf", require("telescope.builtin").git_files, { desc = "[F]ind [G]it [F]iles" })
vim.keymap.set("n", "<leader>fgb", require("telescope.builtin").git_branches, { desc = "[F]ind [G]it [B]ranch" })
vim.keymap.set("n", "<leader>fgc", require("telescope.builtin").git_commits, { desc = "[F]ind [G]it [C]ommits" })
vim.keymap.set("n", "<leader>fgs", require("telescope.builtin").git_status, { desc = "[F]ind [G]it [S]tatus" })
-- Neovim
vim.keymap.set("n", "<leader>fnh", require("telescope.builtin").help_tags, { desc = "[F]ind [N]eovim [H]elp topics" })
vim.keymap.set("n", "<leader>fnc", require("telescope.builtin").commands, { desc = "[F]ind [N]eovim [C]ommands" })
vim.keymap.set("n", "<leader>fnk", require("telescope.builtin").keymaps, { desc = "[F]ind [N]eovim [C]ommands" })

-- VimTest
----------------------------------------------------------------
vim.keymap.set("n", "<leader>tn", [[<cmd>TestNearest<cr>]], { desc = "Run [T]est [N]earest to cursor" })
vim.keymap.set("n", "<leader>tf", [[<cmd>TestFile<cr>]], { desc = "Run all [T]ests in [F]ile" })
vim.keymap.set("n", "<leader>ts", [[<cmd>TestSuite<cr>]], { desc = "Run whole [T]est [S]uite" })
vim.keymap.set("n", "<leader>tl", [[<cmd>TestLast<cr>]], { desc = "Re-Run [T]est we ran [L]ast" })
vim.keymap.set("n", "<leader>tv", [[<cmd>TestVisit<cr>]], { desc = "Return to the last [T]est file and [V]isit" })
