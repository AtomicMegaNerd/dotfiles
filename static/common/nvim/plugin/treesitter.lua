require("nvim-treesitter").setup({})

-- Map Neovim filetypes to parser names where they differ.
local langs = {
  bash = "bash",
  sh = "bash",
  go = "go",
  gomod = "gomod",
  json = "json",
  lua = "lua",
  markdown = "markdown",
  python = "python",
  sql = "sql",
  vim = "vim",
  yaml = "yaml",
  toml = "toml",
  nix = "nix",
  diff = "diff",
  fish = "fish",
  html = "html",
  rust = "rust",
  javascript = "javascript",
  javascriptreact = "javascript",
  typescript = "typescript",
  typescriptreact = "tsx",
  css = "css",
  xml = "xml",
  dockerfile = "dockerfile",
  nu = "nu",
}

local parsers = {}
for ft, lang in pairs(langs) do
  parsers[lang] = true
  if ft ~= lang then
    vim.treesitter.language.register(lang, ft)
  end
end

require("nvim-treesitter").install(vim.tbl_keys(parsers))
local trs_grp = vim.api.nvim_create_augroup("Treesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = trs_grp,
  pattern = vim.tbl_keys(langs),
  callback = function()
    vim.treesitter.start()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldlevel = 99
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})
