local lualine_status, lualine = pcall(require, "lualine")
if not lualine_status then
	return
end

lualine.setup({
	options = {
		theme = "nightfox",
		icons_enabled = false,
		globalstatus = true,
	},
})
