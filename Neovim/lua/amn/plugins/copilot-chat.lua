return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "github/copilot.vim",
       "nvim-lua/plenary.nvim",
    },
    opts = {
      debug = true, 
      show_help = false,
      context = "buffers",
    },
  },
}
