local status, fidget = pcall(require, "fidget")
if not status then
	vim.notify("Cannot load fidget.nvim", vim.log.levels.ERROR)
	return
end

fidget.setup({
	notification = {
		window = {
			winblend = 0,
		},
	},
})
