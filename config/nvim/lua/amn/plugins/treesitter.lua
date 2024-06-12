return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local utils = require("amn.utils")
		local configs = utils.do_import("nvim-treesitter.configs")

		configs.setup({
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
