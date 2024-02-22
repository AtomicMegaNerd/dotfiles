return {
	"j-hui/fidget.nvim",
	priority = 500,
	config = function()
		local utils = require("amn.utils")
		local fidget = utils.do_import("fidget")
		if not fidget then
			return
		end

		fidget.setup({
			notification = {
				window = {
					winblend = 0,
				},
			},
		})
	end,
}
