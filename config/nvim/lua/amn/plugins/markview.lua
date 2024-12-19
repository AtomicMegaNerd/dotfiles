return {
	"OXY2DEV/markview.nvim",
	lazy = false,

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local utils = require("amn.utils")
		local markview = utils.do_import("markview")

		if not markview then
			return
		end

		markview.setup({
			initial_state = false,
		})

		vim.keymap.set("n", "<leader>ms", "<cmd>Markview splitToggle<cr>", { desc = "[M]arkview [S]plit Toggle" })
		vim.keymap.set("n", "<leader>ma", "<cmd>Markview toggleAll<cr>", { desc = "[M]arkview Toggle [A]ll" })
	end,
}
