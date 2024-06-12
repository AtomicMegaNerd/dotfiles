return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		local utils = require("amn.utils")
		local neogit = utils.do_import("neogit")
		neogit.setup({
			integrations = {
				diffview = true,
				telescope = true,
			},
		})
		utils.nmap("<leader>ng", neogit.open, "Open [N]eo[G]it")
	end,
}
