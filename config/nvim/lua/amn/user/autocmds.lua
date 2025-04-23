-- Text yank
----------------------------------------------------------------
-- Automatically highlight text when we yank it
local yank_grp = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = yank_grp,
  pattern = "*",
})

-- Options for specific file types
----------------------------------------------------------------
local fto_grp = vim.api.nvim_create_augroup("FileTypeOptions", { clear = true })

-- Set tabstop and shiftwidth to 2 for these file types
vim.api.nvim_create_autocmd("FileType", {
  command = "set tabstop=2 shiftwidth=2",
  group = fto_grp,
  pattern = { "haskell", "lua", "typescript", "javascript", "terraform", "nix", "markdown" },
})

-- Do not convert tabs to spaces in these file types
vim.api.nvim_create_autocmd("Filetype", {
  command = "set noexpandtab",
  group = fto_grp,
  pattern = { "bash", "sh", "go" },
})

-- The black Python formatter uses 88 characters as the line length
vim.api.nvim_create_autocmd("Filetype", {
  command = "set colorcolumn=88",
  group = fto_grp,
  pattern = { "python" },
})

-- Enable soft wrapping and line breaking in markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  group = fto_grp,
  callback = function()
    vim.opt_local.wrap = true      -- Enable soft wrapping
    vim.opt_local.linebreak = true -- Break lines at word boundaries
  end,
})

-- Treat these files as shell scripts
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = "setf sh",
  group = fto_grp,
  pattern = { "env.list", ".envrc", "*.env" },
})

-- Disable spelling for these file types
vim.api.nvim_create_autocmd("FileType", {
  command = "set nospell",
  group = fto_grp,
  pattern = { "yaml", "json", "toml", "xml" },
})

-- Enable LSP formatting
vim.api.nvim_create_augroup("LspFormatting", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "LspFormatting",
  callback = function()
    vim.notify("Running auto-format", vim.log.levels.INFO)
    vim.lsp.buf.format({ async = false })
  end,
})
