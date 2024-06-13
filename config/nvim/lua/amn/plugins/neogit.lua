return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
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
