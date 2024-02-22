return {
	"williamboman/mason.nvim",
	dependencies = { "williamboman/mason-lspconfig.nvim" },
	config = function()
		local utils = require("amn.utils")

		local mason = utils.do_import("mason")
		if not mason then
			return
		end

		local mason_lsp = utils.do_import("mason-lspconfig")
		if not mason_lsp then
			return
		end

		mason.setup()
		mason_lsp.setup()
	end,
}
