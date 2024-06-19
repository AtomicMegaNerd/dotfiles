return {
	"stevearc/oil.nvim",
	config = function()
		local utils = require("amn.utils")
		local oil = utils.do_import("oil")
		if not oil then
			return
		end
		oil.setup()

		-- Keymaps
		vim.keymap.set("n", "-", "<Cmd>Oil<CR>", { desc = "Open current directory in Oil" })
	end,
}
