local opts = {noremap=true, silent=true}

-- Disable arrow keys while editing, this is vim after all!
vim.api.nvim_set_keymap('n', '<up>','<nop>', opts)
vim.api.nvim_set_keymap('n', '<down>','<nop>', opts)
vim.api.nvim_set_keymap('i', '<up>','<nop>', opts)
vim.api.nvim_set_keymap('i', '<down>','<nop>', opts)
vim.api.nvim_set_keymap('i', '<left>','<nop>', opts)
vim.api.nvim_set_keymap('i', '<right>','<nop>', opts)

-- Left and right can switch bufferse
vim.api.nvim_set_keymap('n', '<left>', '<cmd>bp<cr>', opts)
vim.api.nvim_set_keymap('n', '<right>', '<cmd>bn<cr>', opts)

-- Telescope keybindings
vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>Telescope find_files<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fg', [[<cmd>Telescope live_grep<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>ft', [[<cmd>Telescope git_files<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fb', [[<cmd>Telescope buffers<CR>]], opts)
vim.api.nvim_set_keymap('n', '<leader>fh', [[<cmd>Telescope help_tags<CR>]], opts)

-- VimTest
vim.api.nvim_set_keymap('n', '<leader>tn', [[<cmd>TestNearest<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>tf', [[<cmd>TestFile<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>ts', [[<cmd>TestSuite<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>tl', [[<cmd>TestLast<cr>]], opts)
vim.api.nvim_set_keymap('n', '<leader>tv', [[<cmd>TestVisit<cr>]], opts)
