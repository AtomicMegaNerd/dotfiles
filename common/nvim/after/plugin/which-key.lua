local status, wk = pcall(require, "which-key")
if not status then
	vim.notify("Cannot load which-key.nvim", vim.log.levels.ERROR)
	return
end

wk.setup()
