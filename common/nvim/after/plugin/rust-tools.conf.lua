local status, rt = pcall(require, "rust-tools")
if not status then
  vim.notify("Could not load rust-tools", vim.log.levels.WARNING)
  return
end

rt.setup()
