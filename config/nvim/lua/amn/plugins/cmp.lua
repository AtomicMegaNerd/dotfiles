return {
	"saghen/blink.cmp",
	version = "*",
	opts = {
		enabled = function()
			return not vim.tbl_contains({ "copilot-chat" }, vim.bo.filetype)
		end,
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "buffer" },
		},
		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
