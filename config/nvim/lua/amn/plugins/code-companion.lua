return {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local utils = require("amn.utils")
    local codecompanion = utils.do_import("codecompanion")
    if not codecompanion then
      return
    end
    codecompanion.setup({
      display = {
        action_palette = {
          prompt = "Prompt ",
          provider = "fzf_lua",
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
        },
      },
    })
    vim.keymap.set(
      "n", "<leader>pc", "<Cmd>CodeCompanionChat Toggle<CR>", { desc = "Open Code Companion Chat" }
    )
    vim.keymap.set(
      "n", "<leader>pi", "<Cmd>CodeCompanion<CR>", { desc = "Open Code Companion Inline" }
    )
    vim.keymap.set(
      "n", "<leader>pa", "<Cmd>CodeCompanionActions<CR>", { desc = "Open Code Companion Actions" }
    )
  end,
}
