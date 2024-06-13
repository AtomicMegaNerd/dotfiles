if vim.env.NVIM_ENALBLE_MASON == "1" then
	return {
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			local utils = require("amn.utils")
			local mason = utils.do_import("mason")

			if not mason then
				return
			end

			mason.setup()
		end,
	}
else
	return {}
end
