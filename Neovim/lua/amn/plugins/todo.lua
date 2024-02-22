return {
	"folke/todo-comments.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		local utils = require("amn.utils")
		local todo = utils.do_import("todo-comments")
		if not todo then
			return
		end
		todo.setup()
	end,
}
