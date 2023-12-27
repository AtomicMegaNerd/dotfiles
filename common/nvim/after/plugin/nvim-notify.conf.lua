local status, notify = pcall(require, "notify")
if not status then
  vim.notify("Cannot load notify", vim.log.levels.ERROR)
  return
end

notify.setup({
  background_color = "#000000",
})

vim.notify = notify
