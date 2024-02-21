return {
	"nvim-treesitter/nvim-treesitter",
	cmd = "TSUpdate",
	config = function()
		local status, ts = pcall(require, "nvim-treesitter.configs")
		if not status then
			vim.notify("nvim-treesitter not found", vim.log.levels.ERROR)
			return
		end
		ts.setup({
			highlight = {
				enable = true,
				disable = {},
			},
			indent = {
				enable = true,
				disable = { "python", "go" },
			},
		})
	end,
}
