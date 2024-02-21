local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
  vim.notify("Cannot load nvim-treesitter", vim.log.levels.ERROR)
  return
end

ts.setup({
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = { "python", "go" },
  },
})
