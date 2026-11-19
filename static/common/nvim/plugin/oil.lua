local oil = require("oil")
local map = vim.keymap.set

oil.setup({
  columns = { "icon", "size", "mtime" },
  view_options = { show_hidden = true },
})

map("n", "<leader>o", "<Cmd>Oil<CR>", { desc = "Open current directory in Oil" })
