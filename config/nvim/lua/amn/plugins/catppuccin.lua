return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	init = function()
		vim.o.termguicolors = true
	end,
	config = function()
		local utils = require("amn.utils")
		local catppuccin = utils.do_import("catppuccin")

		if not catppuccin then
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
	end,
}
