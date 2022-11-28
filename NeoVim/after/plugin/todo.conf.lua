local todo_status, todo = pcall(require, "todo-comments")
if not todo_status then
	return
end

todo.setup()
