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
		"typescript",
		"javascript",
		"tsx",
		"toml",
		"html",
		"css",
		"json",
	},
	highlight = {
		enable = true,
		disable = {},
	},
	indent = {
		enable = true,
		disable = { "python", "go" },
	},
})
