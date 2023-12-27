local status, mason = pcall(require, "mason")
if not status then
  vim.notify("Cannot load mason", vim.log.levels.ERROR)
  return
end

mason.setup()
