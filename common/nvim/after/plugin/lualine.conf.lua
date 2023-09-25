local status, lualine = pcall(require, "lualine")
if not status then
	return
end

lualine.setup({
	options = {
		theme = "auto",
		icons_enabled = false,
		globalstatus = true,
		section_separators = "█",
		component_separators = "|",
	},
})
