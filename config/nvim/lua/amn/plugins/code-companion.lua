return {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-treesitter/nvim-treesitter", branch = "main" },
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
        chat = {
          -- Replace current buffer instead of creating a split
          window = {
            layout = "buffer", -- This replaces the current buffer
          },
          -- Make sure it shows in buffer list
          show_settings = true,
          show_token_count = true,
        },
      },
      memory = {
        opts = {
          chat = {
            enabled = true,
          },
        },
      },
    })

    -- Key mappings
    utils.nmap("<leader>pc", "<Cmd>CodeCompanionChat Toggle<CR>", "Open Code Companion Chat")
    utils.nmap("<leader>pi", "<Cmd>CodeCompanion<CR>", "Open Code Companion Inline")
    utils.nmap("<leader>pa", "<Cmd>CodeCompanionActions<CR>", "Open Code Companion Actions")
  end,
}
