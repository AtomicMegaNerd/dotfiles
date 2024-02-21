return {
	"rcarriga/nvim-notify",
	priority = 100,
	config = function()
		local status, notify = pcall(require, "notify")
		if not status then
			vim.notify("Failed to load notify", vim.log.levels.ERROR)
			return
		end
		notify.setup({
			background_colour = "#000000",
			render = "compact",
		})
		vim.notify = notify
	end,
}
