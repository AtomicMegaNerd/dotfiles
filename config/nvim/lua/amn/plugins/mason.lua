-- Only include mason if we set the NVIM_ENABLE_MASON environment variable
if vim.env.NVIM_ENABLE_MASON == 1 then
	vim.notify("Mason enabled on this system!", vim.log.levels.INFO)
	return {
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			local utils = require("amn.utils")
			local mason = utils.do_import("mason")
			mason.setup()
		end,
	}
else
	return {}
end
