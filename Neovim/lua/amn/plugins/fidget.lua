return {
	"j-hui/fidget.nvim",
	priority = 500,
	config = function()
		local status, fidget = pcall(require, "fidget")
		if not status then
			vim.notify("Failed to load fidget", vim.log.levels.ERROR)
			return
		end
		fidget.setup({
			notification = {
				window = {
					winblend = 0,
				},
			},
		})
	end,
}
