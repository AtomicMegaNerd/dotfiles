local status, lualine = pcall(require, "lualine")
if not status then
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
