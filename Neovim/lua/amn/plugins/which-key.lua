return {
	"folke/which-key.nvim",
	init = function()
		vim.o.timeoutlen = 1000
	end,
	config = function()
		local utils = require("amn.utils")
		local wk = utils.do_import("which-key")
		if not wk then
			return
		end

		wk.setup()
	end,
}
