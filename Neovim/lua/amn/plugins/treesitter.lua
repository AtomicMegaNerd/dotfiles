return {
	"nvim-treesitter/nvim-treesitter",
	cmd = "TSUpdate",
	config = function()
		local utils = require("amn.utils")
		local ts = utils.do_import("nvim-treesitter.configs")
		if not ts then
			return
		end

		ts.setup({
			highlight = {
				enable = true,
				disable = {},
			},
			indent = {
				enable = true,
				disable = { "python", "go" },
			},
		})
	end,
}
