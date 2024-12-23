return {
	"saghen/blink.cmp",

	version = "*",

	opts = {
		keymap = { preset = "default" },

		appearance = {
			nerd_font_variant = "normal",
		},

		sources = {
			default = { "lsp", "path", "buffer" },
		},

		opts_extend = { "sources.default" },
	},
	opts_extend = { "sources.default" },
}
