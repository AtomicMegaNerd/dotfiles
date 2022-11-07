require("nvim-treesitter.configs").setup({
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
