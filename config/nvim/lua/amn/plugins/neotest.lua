return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "fredrikaverpil/neotest-golang",
    "nvim-neotest/neotest-python",
  },
  opts = {
    discovery = {
      enabled = false,
      concurrent = 1,
    },
    running = {
      concurrent = true,
    },
  },
  config = function()
    local utils = require("amn.utils")
    local neotest = utils.do_import("neotest")
    if not neotest then
      return
    end

    local nt_python = utils.do_import("neotest-python")
    local nt_golang = utils.do_import("neotest-golang")

    if not nt_python or not nt_golang then
      return
    end

    if not neotest then
      return
    end

    neotest.setup({
      adapters = {
        nt_python({}),
        nt_golang({}),
      },
    })

    vim.g["test#strategy"] = "neovim"

    utils.nmap("<leader>tn", function()
      neotest.run.run()
      neotest.output.open()
    end, "Run [T]est [N]earest to cursor")

    utils.nmap("<leader>tf", function()
      neotest.run.run(vim.fn.expand("%"))
      neotest.output.open()
    end, "Run all [T]ests in [F]ile")

    utils.nmap("<leader>ts", function()
      neotest.run.run(vim.fn.getcwd())
      neotest.output.open()
    end, "Run whole [T]est [S]uite")
  end,
}
