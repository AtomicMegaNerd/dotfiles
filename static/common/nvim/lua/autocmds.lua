local amn_grp = vim.api.nvim_create_augroup("AtomicMegaNerdGroup", { clear = true })

-- These languages are best using 2-spaces for indentation
local two_space = {
  "haskell",
  "lua",
  "terraform",
  "nix",
  "markdown",
  "yaml",
  "html",
  "xml",
  "css",
  "json",
  "scss",
  "toml",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

-- These languages use tabs instead of spaces
local use_tabs = {
  "go",
  "make",
}

-- This autocmd controls indentation and tabs vs. spaces for
-- all our file types
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ft = args.match
    -- Default to spaces
    vim.bo[args.buf].expandtab = true
    -- Set indendtation to 2 for languages in two_space table
    if vim.tbl_contains(two_space, ft) then
      vim.bo[args.buf].tabstop = 2
      vim.bo[args.buf].shiftwidth = 2
    end
    -- Use tabs for languages in the use_tabs table
    if vim.tbl_contains(use_tabs, ft) then
      vim.bo[args.buf].expandtab = false
    end
  end,
  group = amn_grp,
})

-- Markdown is soft-wrapped, not hard-wrapped, so the column guide is just noise
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.wo.colorcolumn = ""
  end,
  group = amn_grp,
})

-- Treat these files as shell scripts
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = "setf sh",
  group = amn_grp,
  pattern = { "env.list", ".envrc", "*.env" },
})
