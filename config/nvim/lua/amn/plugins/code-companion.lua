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

    utils.nmap("<leader>pc", "<Cmd>CodeCompanionChat Toggle<CR>", "Open Code Companion Chat")
    utils.namp("<leader>pi", "<Cmd>CodeCompanion<CR>", "Open Code Companion Inline")
    utils.nmap("<leader>pa", "<Cmd>CodeCompanionActions<CR>", "Open Code Companion Actions")
  end,
}
