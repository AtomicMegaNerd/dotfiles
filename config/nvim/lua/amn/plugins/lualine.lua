return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local utils = require("amn.utils")
		local lualine = utils.do_import("lualine")

		lualine.setup({
			options = {
				theme = "catppuccin",
				icons_enabled = false,
				globalstatus = true,
			},
			extensions = { "fugitive" },
		})
	end,
}
