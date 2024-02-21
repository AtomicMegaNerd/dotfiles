return {
	"stevearc/conform.nvim",
	config = function()
		local status, conform = pcall(require, "conform")
		if not status then
			vim.notify("Cannot load conform", vim.log.levels.ERROR)
			return
		end
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
