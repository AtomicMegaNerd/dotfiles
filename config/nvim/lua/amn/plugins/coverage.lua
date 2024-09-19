return {
	"andythigpen/nvim-coverage",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
	config = function()
		local utils = require("amn.utils")
		local cov = utils.do_import("coverage")
		if not cov then
			return
		end
		cov.setup({
			lang = {
				go = {
					coverage_file = "cover.out",
				},
			},
		})
	end,
}
