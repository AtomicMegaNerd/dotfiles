return {
  "nvim-mini/mini.nvim",
  version = "*",

  config = function()
    local utils = require("amn.utils")
    local mini_icons = utils.do_import("mini.icons")
    if not mini_icons then
      return
    end

    mini_icons.setup()
  end,
}
