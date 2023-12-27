local status, neodev = pcall(require, "neodev")
if not status then
  vim.notify("Cannot load neodev", vim.log.levels.ERROR)
  return
end

neodev.setup()
