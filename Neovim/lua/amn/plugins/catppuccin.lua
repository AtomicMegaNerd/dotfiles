return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		local status, catppuccin = pcall(require, "catppuccin")
		if not status then
			vim.notify("Cannot load catppuccin", vim.log.levels.ERROR)
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
		vim.o.termguicolors = true
		vim.cmd.colorscheme("catppuccin")
	end,
}
