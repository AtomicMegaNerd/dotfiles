require("lint").linters_by_ft = {
  go = { "golangcilint" },
  yaml = { "yamllint" },
  markdown = { "markdownlint-cli2" },
}

local linting = vim.api.nvim_create_augroup("Linting", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = linting,
  callback = function()
    local lint = require("lint")
    lint.try_lint()
  end,
})
