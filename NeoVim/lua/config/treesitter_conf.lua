require("nvim-treesitter.configs").setup({
	ensure_installed = { "python", "go", "haskell", "rust", "fish", "bash", "lua", "markdown", "yaml" },
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = { "python", "go" },
	},
})
