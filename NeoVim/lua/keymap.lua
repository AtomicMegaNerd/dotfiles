local opts = { noremap = true, silent = true }

-- Disable arrow keys while editing, this is vim after all!
vim.api.nvim_set_keymap("n", "<up>", "<nop>", opts)
vim.api.nvim_set_keymap("n", "<down>", "<nop>", opts)
vim.api.nvim_set_keymap("i", "<up>", "<nop>", opts)
vim.api.nvim_set_keymap("i", "<down>", "<nop>", opts)
vim.api.nvim_set_keymap("i", "<left>", "<nop>", opts)
vim.api.nvim_set_keymap("i", "<right>", "<nop>", opts)

-- Left and right can switch buffers
vim.api.nvim_set_keymap("n", "<left>", "<cmd>bp<cr>", opts)
vim.api.nvim_set_keymap("n", "<right>", "<cmd>bn<cr>", opts)

-- Telescope keybindings
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>ft", require("telescope.builtin").git_files)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)

-- VimTest
vim.api.nvim_set_keymap("n", "<leader>tn", [[<cmd>TestNearest<cr>]], opts)
vim.api.nvim_set_keymap("n", "<leader>tf", [[<cmd>TestFile<cr>]], opts)
vim.api.nvim_set_keymap("n", "<leader>ts", [[<cmd>TestSuite<cr>]], opts)
vim.api.nvim_set_keymap("n", "<leader>tl", [[<cmd>TestLast<cr>]], opts)
vim.api.nvim_set_keymap("n", "<leader>tv", [[<cmd>TestVisit<cr>]], opts)

-- Formatter
vim.keymap.set("n", "<leader>f", ":Format<CR>")
