local fmt_status, fmt = pcall(require, "conform")
if not fmt_status then
  vim.notify("Cannot load formatter", vim.log.levels.ERROR)
  return
end

fmt.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    sh = { "shfmt" },
    go = { "gofmt" },
    rust = { "rustfmt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
  },
})
