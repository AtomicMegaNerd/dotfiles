return {
  "stevearc/oil.nvim",
  config = function()
    local utils = require("amn.utils")
    local oil = utils.do_import("oil")
    if not oil then
      return
    end

    oil.setup({
      view_options = {
        show_hidden = true,
      },
    })

    utils.nmap("<leader>o", "<Cmd>Oil<CR>", "Open current directory in Oil")
  end,
}
