return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  config = function()
    local utils = require("amn.utils")
    local ntt = utils.do_import("nvim-treesitter-textobjects")
    if not ntt then
      return
    end

    ntt.setup({
      move = {
        -- whether to set jumps in the jumplist
        set_jumps = true,
      },
    })

    local move = utils.do_import("nvim-treesitter-textobjects.move")
    if not move then
      return
    end

    local select = utils.do_import("nvim-treesitter-textobjects.select")
    if not select then
      return
    end

    -- Move
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      move.goto_next_start("@function.outer")
    end, { desc = "Next function start" })
    vim.keymap.set({ "n", "x", "o" }, "]F", function()
      move.goto_next_end("@function.outer")
    end, { desc = "Next function end" })
    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      move.goto_previous_start("@function.outer")
    end, { desc = "Prev function start" })
    vim.keymap.set({ "n", "x", "o" }, "[F", function()
      move.goto_previous_end("@function.outer")
    end, { desc = "Prev function end" })
    vim.keymap.set({ "n", "x", "o" }, "]c", function()
      move.goto_next_start("@class.outer")
    end, { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "[c", function()
      move.goto_previous_start("@class.outer")
    end, { desc = "Prev class start" })

    -- Select (visual + operator-pending only)
    vim.keymap.set({ "x", "o" }, "af", function()
      select.select_textobject("@function.outer", "textobjects")
    end, { desc = "Around function" })
    vim.keymap.set({ "x", "o" }, "if", function()
      select.select_textobject("@function.inner", "textobjects")
    end, { desc = "Inside function" })
    vim.keymap.set({ "x", "o" }, "ac", function()
      select.select_textobject("@class.outer", "textobjects")
    end, { desc = "Around class" })
    vim.keymap.set({ "x", "o" }, "ic", function()
      select.select_textobject("@class.inner", "textobjects")
    end, { desc = "Inside class" })
    vim.keymap.set({ "x", "o" }, "aa", function()
      select.select_textobject("@parameter.outer", "textobjects")
    end, { desc = "Around parameter" })
    vim.keymap.set({ "x", "o" }, "ia", function()
      select.select_textobject("@parameter.inner", "textobjects")
    end, { desc = "Inside parameter" })
  end,
}
