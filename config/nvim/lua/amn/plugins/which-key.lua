return {
	"folke/which-key.nvim",
	init = function()
		vim.o.timeoutlen = 1000
	end,
	config = function()
		local utils = require("amn.utils")
		local wk = utils.do_import("which-key")

		wk.setup()
	end,
}
