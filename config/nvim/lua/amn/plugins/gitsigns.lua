return {
	"lewis6991/gitsigns.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local utils = require("amn.utils")
		local gitsigns = utils.do_import("gitsigns")

		if not gitsigns then
			return
		end

		gitsigns.setup()
	end,
}
