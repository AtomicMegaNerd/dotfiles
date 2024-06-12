return {
	"stevearc/conform.nvim",
	config = function()
		local utils = require("amn.utils")
		local conform = utils.do_import("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				sh = { "shfmt" },
				go = { "gofmt" },
				rust = { "rustfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
			},
		})
	end,
}
