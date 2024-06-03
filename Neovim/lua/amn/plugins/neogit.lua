return {
	"neogitorg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
		"ibhagwan/fzf-lua",
	},
	config = function()
		local utils = require("amn.utils")
		if not utils then
			vim.notify("Utils not found", vim.log.levels.ERROR)
			return
		end

		local neogit = utils.do_import("neogit")
		if not neogit then
			return
		end

		neogit.setup({
			integrations = {
				diffview = true,
				telescope = true,
				fzf_lua = true,
			},
		})

		utils.nmap("<leader>ng", neogit.open)
	end,
}
