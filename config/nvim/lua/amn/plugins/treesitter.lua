if vim.env.NON_NIX_SYSTEM == 1 then
	vim.notify("Non-Nix system deteceted: Tree-Sitter enabled via Lazy!", vim.log.levels.INFO)
	return {
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local utils = require("amn.utils")
			local configs = utils.do_import("nvim-treesitter.configs")

			configs.setup({
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			})
		end,
	}
else
	return {}
end
