local status, fidget = pcall(require, "fidget")
if not status then
  return
end

fidget.setup({
  notification = {
    window = {
      winblend = 0,
    },
  },
})
