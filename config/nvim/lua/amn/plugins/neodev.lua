return {
	"folke/neodev.nvim",
	config = function()
		local utils = require("amn.utils")
		local neodev = utils.do_import("neodev")

		neodev.setup()
	end,
}
