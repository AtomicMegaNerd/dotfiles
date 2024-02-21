return {
	"folke/todo-comments.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		local status, todo = pcall(require, "todo-comments")
		if not status then
			vim.notify("Cannot load todo-comments", vim.log.levels.ERROR)
			return
		end
		todo.setup()
	end,
}
