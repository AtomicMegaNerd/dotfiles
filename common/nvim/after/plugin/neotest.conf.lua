local status, neotest = pcall(require, "neotest")
if not status then
	return
end

-- Setup neotest with the adapters
neotest.setup({
	adapters = {
		require("neotest-python"),
		require("neotest-go"),
		require("neotest-rust"),
	},
})
