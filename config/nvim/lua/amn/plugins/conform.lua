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
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				conform.format({ bufnr = args.buf })
			end,
		})
	end,
}
