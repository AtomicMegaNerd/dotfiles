local status, todo = pcall(require, "todo-comments")
if not status then
	vim.notify("Cannot load todo-comments.nvim", vim.log.levels.ERROR)
	return
end

todo.setup()
