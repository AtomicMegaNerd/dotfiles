local status, neogit = pcall(require, "neogit")
if not status then
	vim.notify("Cannot load neogit.nvim", vim.log.levels.ERROR)
	return
end

neogit.setup()
