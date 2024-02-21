return {
	"williamboman/mason.nvim",
	dependencies = { "williamboman/mason-lspconfig.nvim" },
	config = function()
		local m_status, mason = pcall(require, "mason")
		if not m_status then
			vim.notify("Cannot load mason", vim.log.levels.ERROR)
			return
		end
		local ml_status, mason_lsp = pcall(require, "mason-lspconfig")
		if not ml_status then
			vim.notify("Cannot load mason-lspconfig", vim.log.levels.ERROR)
			return
		end

		mason.setup()
		mason_lsp.setup()
	end,
}
