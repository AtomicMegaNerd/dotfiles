return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local utils = require("amn.utils")
    local ts = utils.do_import("nvim-treesitter")

    if not ts then
      return
    end

    ts.setup()
  end,
}
