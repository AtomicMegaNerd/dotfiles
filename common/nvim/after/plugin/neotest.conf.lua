local nt_status, nt = pcall(require, "neotest")
if not nt_status then
	return
end

nt.setup({
	adaptors = {
		require("neotest-python"),
		require("neotest-rust"),
		require("neotest-go"),
		require("neotest-haskell"),
	},
})
