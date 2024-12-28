return {
	"saghen/blink.cmp",
	version = "*",
	opts = {
		keymap = { preset = "super-tab" },
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
