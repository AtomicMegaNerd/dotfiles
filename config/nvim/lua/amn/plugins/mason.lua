if vim.env.NON_NIX_SYSTEM == 1 then
	vim.notify("Non-nix system detected: Mason enabled!", vim.log.levels.INFO)
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
