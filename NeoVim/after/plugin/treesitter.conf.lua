local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

ts.setup({
	ensure_installed = {
		"python",
		"go",
		"haskell",
		"rust",
		"fish",
		"bash",
		"lua",
		"yaml",
		"vim",
		"yaml",
	},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = { "python", "go" },
	},
})
