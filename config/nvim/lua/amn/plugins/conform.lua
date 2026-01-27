return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		local utils = require("amn.utils")
		local conform = utils.do_import("oil")
		if not conform then
			return
		end

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier", stop_after_first = true },
				json = { "prettier" },
				yaml = { "prettier" },
			},
		})
	end,
}
