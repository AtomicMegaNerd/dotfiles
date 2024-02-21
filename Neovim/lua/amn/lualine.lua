local status, lualine = pcall(require, "lualine")
if not status then
	vim.notify("Cannot load lualine", vim.log.levels.ERROR)
	return
end

lualine.setup({
	options = {
		theme = "catppuccin",
		icons_enabled = false,
		globalstatus = true,
	},
	extensions = { "fugitive" },
})
