-- If CLI_THEME environment variable is set to "catppuccin" then
-- we want to load this plug-in.

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,

	config = function()
		local utils = require("amn.utils")
		local catppuccin = utils.do_import("catppuccin")

		if not catppuccin then
			return
		end

		catppuccin.setup({
			flavour = "latte",
			no_italic = true,
			transparent_background = true,
			integrations = {
				gitsigns = true,
				fzf = true,
				snacks = true,
				which_key = true,
				trouble = true,
				neotest = true,
				neogit = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
