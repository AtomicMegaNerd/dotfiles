local status, catppuccin = pcall(require, "catppuccin")
if not status then
	vim.notify("Could not load catppuccin", vim.log.levels.WARNING)
	return
end

catppuccin.setup({
	flavour = "frappe",
	no_italic = true,
	background = {
		light = "lattle",
		dark = "frappe",
	},
})
