require("neotest").setup({
	adapters = {
		require("neotest-python"),
		require("neotest-rust"),
		require("neotest-go"),
		require("neotest-haskell"),
	},
})
