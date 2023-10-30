local status, catppuccin = pcall(require, "catppuccin")
if not status then
	return
end

print("Hello, world!")

catppuccin.setup({
	flavour = "frappe",
	no_italic = true,
	background = {
		light = "lattle",
		dark = "mocha",
	},
})
