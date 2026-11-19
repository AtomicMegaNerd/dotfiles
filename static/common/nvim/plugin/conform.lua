require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "goimports", "golines" },
    bash = { "shfmt" },
  },
  format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
})
