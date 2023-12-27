local status, notify = pcall(require, "notify")
if not status then
  vim.notify("Failed to load notify" .. notify, vim.log.levels.ERROR)
  return
end

notify.setup({
  background_colour = "#000000",
})

vim.notify = notify
