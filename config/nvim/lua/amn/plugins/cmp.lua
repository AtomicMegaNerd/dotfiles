return {
  "saghen/blink.cmp",
  version = "*",
  opts = {
    appearance = {
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "buffer" },
      per_filetype = {
        codecompanion = { "codecompanion" },
      }
    },
    signature = { enabled = true },
  },
  opts_extend = { "sources.default" },
}
