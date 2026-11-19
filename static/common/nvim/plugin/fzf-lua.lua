local fzf = require("fzf-lua")

fzf.setup({
  defaults = {
    icon_provider = "mini",
  },
  winopts = {
    backdrop = 60,
  },
})

local map = vim.keymap.set

-- Files
map("n", "<leader>ff", fzf.files, { desc = "[F]ind [F]iles" })
map("n", "<leader>fb", fzf.buffers, { desc = "[F]ind [B]uffers" })
map("n", "<leader>fl", fzf.live_grep, { desc = "[F]ind [L]ive grep" })
map("n", "<leader>fh", fzf.help_tags, { desc = "[F]ind [H]elp tags" })

-- LSP
map("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "[F]ind [S]ymbols" })
map("n", "<leader>fw", fzf.lsp_workspace_symbols, { desc = "[F]ind [W]orkspace symbols" })

-- Diagnostics
map("n", "<leader>fd", fzf.diagnostics_document, { desc = "[F]ind Document [d]iagnostics" })
map("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "[F]ind Workspace [D]iagnostics" })

-- Lists / other
map("n", "<leader>fm", function()
  local lines = vim.split(vim.fn.execute("messages"), "\n", { plain = true })
  lines = vim.tbl_filter(function(l)
    return l ~= ""
  end, lines)
  fzf.fzf_exec(lines, { prompt = "Messages> " })
end, { desc = "[F]ind [M]essages" })

-- Key maps
map("n", "<leader>fk", fzf.keymaps, { desc = "[F]ind [K]eymaps" })

-- Git
map("n", "<leader>fgf", fzf.git_files, { desc = "[F]ind [G]it [F]iles" })
map("n", "<leader>fgc", fzf.git_commits, { desc = "[F]ind [G]it [C]ommits" })
map("n", "<leader>fgb", fzf.git_branches, { desc = "[F]ind [G]it [B]ranches" })
