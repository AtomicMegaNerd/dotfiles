return {
	"folke/todo-comments.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		local utils = require("amn.utils")
		local todo = utils.do_import("todo-comments")

		todo.setup()
	end,
}
