return {
	"saghen/blink.cmp",
	version = "v0.8.1",
	opts = {
		keymap = { preset = "default" },
		appearance = {
			nerd_font_variant = "normal",
		},
		sources = {
			default = { "lsp", "path", "buffer" },
		},
		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
