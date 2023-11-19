local status, catppuccin = pcall(require, "catppuccin")
if not status then
  vim.notify("Could not load catppuccin", vim.log.levels.WARNING)
  return
end

catppuccin.setup({
  flavour = "frappe",
  no_italic = true,
  transparent_background = true,
  integrations = {
    cmp = true,
    gitsigns = true,
    treesitter = true,
    alpha = true,
    telescope = true,
    fidget = true,
  },
})

vim.cmd.colorscheme("catppuccin")
