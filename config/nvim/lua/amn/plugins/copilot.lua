return {
	"github/copilot.vim",
	init = function()
		vim.g.copilot_assume_mapped = true
		vim.g.copilot_proxy_strict_ssl = false
		vim.g.copilot_enabled = false
	end,
}
