return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	config = function()
		local utils = require("amn.utils")
		local neogit = utils.do_import("neogit")

		if not neogit then
			return
		end

		neogit.setup({
			integrations = {
				diffview = true,
				fzf_lua = true,
			},
		})
		utils.nmap("<leader>ng", neogit.open, "Open [N]eo[G]it")
	end,
}
