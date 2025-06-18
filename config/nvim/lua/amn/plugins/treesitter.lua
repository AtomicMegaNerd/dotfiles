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

    ts.install({
      "bash",
      "dockerfile",
      "go",
      "json",
      "lua",
      "markdown",
      "python",
      "sql",
      "vim",
      "yaml",
      "toml",
      "nix",
      "diff",
      "jsonc",
    })
  end,
}
