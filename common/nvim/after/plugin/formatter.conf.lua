local fmt_status, fmt = pcall(require, "conform")
if not fmt_status then
	vim.notify("Cannot load conform.nvim", vim.log.levels.ERROR)
	return
end

fmt.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		sh = { "shfmt" },
		json = { "prettier" },
		yaml = { "prettier" },
		nix = { "nixfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		rust = { "rustfmt" },
		go = { "gofmt" },
	},
})
