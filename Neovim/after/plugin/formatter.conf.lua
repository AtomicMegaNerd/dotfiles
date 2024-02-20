local status, fmt = pcall(require, "conform")
if not status then
	vim.notify("Cannot load conform.nvim", vim.log.levels.ERROR)
	return
end

fmt.setup({
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
