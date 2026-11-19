require("no-neck-pain").setup({
  width = 110, -- Need to account for signcolumn and numbercolumn
  minSideBufferWidth = 1,
  buffers = {
    wo = {
      signcolumn = "no",
    },
  },
  autocmds = {
    enableOnVimEnter = true,
  },
  mappings = {
    enabled = true,
  },
  integrations = {
    dashboard = {
      enabled = true,
      -- Besides the dashboard, list floating-window filetypes (Neovim 0.12 ui2 + mini.notify).
      -- The plugin's FileType safety net otherwise fires on them, skips (floating window), and
      -- deletes its own autocmd group, so it never auto-enables when a file is opened.
      filetypes = { "ministarter", "mininotify", "cmd", "dialog", "msg", "pager" },
    },
  },
})
