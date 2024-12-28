-- If CLI_THEME environment variable is set to "catppuccin" then
-- we want to load this plug-in.

if vim.fn.getenv("CLI_THEME") == "catppuccin" then
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
				flavour = "macchiato",
				no_italic = true,
				transparent_background = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					fzf = true,
					snacks = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	}
else
	return {}
end
