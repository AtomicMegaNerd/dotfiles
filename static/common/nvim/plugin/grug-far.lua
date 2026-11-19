local grug = require("grug-far")
local map = vim.keymap.set

grug.setup({})

map({ "n", "v" }, "<leader>cg", function()
  require("grug-far").open({ transient = true })
end, { desc = "[C]ode [G]rug (Find)" })
