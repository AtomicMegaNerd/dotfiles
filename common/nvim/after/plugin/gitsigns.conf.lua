local status, gs = pcall(require, "gitsigns")
if not status then
  vim.notify("Cannot load gitsigns", vim.log.levels.ERROR)
  return
end

gs.setup({
  signs = {
    add = { hl = "GitGutterAdd", text = "+" },
    change = { hl = "GitGutterChange", text = "~" },
    delete = { hl = "GitGutterDelete", text = "_" },
    topdelete = { hl = "GitGutterDelete", text = "‾" },
    changedelete = { hl = "GitGutterChange", text = "~" },
  },
})
