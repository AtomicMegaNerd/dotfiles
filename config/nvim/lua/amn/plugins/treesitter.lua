return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local utils = require("amn.utils")
    local configs = utils.do_import("nvim-treesitter.configs")

    if not configs then
      return
    end

    configs.setup({
      auto_install = false,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "go" },
      },
    })
  end,
}
