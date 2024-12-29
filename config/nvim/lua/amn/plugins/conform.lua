return {
	"stevearc/conform.nvim",
	config = function()
		local utils = require("amn.utils")
		local conform = utils.do_import("conform")

		if not conform then
			return
		end

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				sh = { "shfmt" },
				go = { "gofmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				nix = { "nixfmt" },
			},
			format_on_save = {
				-- I recommend these options. See :help conform.format for details.
				lsp_format = "fallback",
				timeout_ms = 500,
			},
		})
	end,
}
