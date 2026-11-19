local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
  keymap = { preset = "enter" },

  completion = {
    list = { selection = { preselect = true, auto_insert = true } },
    menu = {
      draw = {
        padding = 1,
        columns = { { "label" }, { "kind_icon", "kind" }, { "source_name" } },
      },
    },
    ghost_text = { enabled = false },
  },

  sources = {
    default = { "lsp", "path", "buffer" },
    per_filetype = {
      html = { "lsp", "path" },
      javascriptreact = { "lsp", "path" },
      markdown = { "lsp", "path" },
      typescriptreact = { "lsp", "path" },
    },
  },

  signature = { enabled = true },
})
