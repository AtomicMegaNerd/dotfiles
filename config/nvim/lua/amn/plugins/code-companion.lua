return {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local utils = require("amn.utils")
    local codecompanion = utils.do_import("codecompanion")
    if not codecompanion then
      return
    end
    codecompanion.setup()
    vim.keymap.set(
      "n", "<leader>pc", "<Cmd>CodeCompanionChat<CR>", { desc = "Open Code Companion Chat" }
    )
    vim.keymap.set(
      "n", "<leader>pi", "<Cmd>CodeCompanion<CR>", { desc = "Open Code Companion Inline" }
    )
  end,
}
