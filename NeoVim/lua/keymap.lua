--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
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
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>ft", require("telescope.builtin").git_files)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)

-- VimTest
vim.keymap.set("n", "<leader>tn", [[<cmd>TestNearest<cr>]])
vim.keymap.set("n", "<leader>tf", [[<cmd>TestFile<cr>]])
vim.keymap.set("n", "<leader>ts", [[<cmd>TestSuite<cr>]])
vim.keymap.set("n", "<leader>tl", [[<cmd>TestLast<cr>]])
vim.keymap.set("n", "<leader>tv", [[<cmd>TestVisit<cr>]])
