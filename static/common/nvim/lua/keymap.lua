local map = vim.keymap.set

-- Disable arrow keys for editing
map("n", "<up>", "<nop>")
map("n", "<down>", "<nop>")
map("i", "<up>", "<nop>")
map("i", "<down>", "<nop>")
map("i", "<left>", "<nop>")
map("i", "<right>", "<nop>")

-- Remap ; to : for normal mode
map("n", ";", ":")

-- Left and right can switch buffers
map("n", "<left>", "<cmd>bp<cr>")
map("n", "<right>", "<cmd>bn<cr>")

-- Undo/Redo re-mappings (always use the leader key)
map("n", "u", "<nop>")
map("n", "U", "<nop>")
map("n", "<C-r>", "<nop>")
map("n", "<leader>u", "u", { desc = "Undo" })
map("n", "<leader>U", "U", { desc = "Undo Line" })
map("n", "<leader>r", "<C-r>", { desc = "Redo" })

-- Delete without overwriting the clipboard
map("n", "x", '"_x')

-- Vim Pack
map("n", "<leader>pu", vim.pack.update, { desc = "Vim [P]ack [U]pdate" })

-- Health Checks
map("n", "<leader>kl", "<cmd>:checkhealth vim.lsp<cr>", { desc = "Chec[K] Health [L]sp" })
map("n", "<leader>kp", "<cmd>:checkhealth vim.pack<cr>", { desc = "Chec[K] Health [P]ack" })
map(
  "n",
  "<leader>kt",
  "<cmd>:checkhealth nvim-treesitter<cr>",
  { desc = "Chec[K] Health [T]ree-sitter" }
)

-- Directory Management key mappings
map(
  "n",
  "<leader>dc",
  "<cmd>:lcd %:p:h<cr>",
  { desc = "[D]irectory change to [C]urrent file directory" }
)
map("n", "<leader>dr", function()
  local root = vim.fs.root(0, { ".git" })
  if root then
    vim.cmd.lcd(root)
  end
end, { desc = "[D]irectory change to [R]oot" })
map("n", "<leader>dl", "<cmd>lcd -<cr>", { desc = "[D]irectory change to [L]ast" })

-- Disable creating and jumping to marks
map({ "n", "v" }, "m", "<Nop>")
map({ "n", "v" }, "'", "<Nop>")
map({ "n", "v" }, "`", "<Nop>")
