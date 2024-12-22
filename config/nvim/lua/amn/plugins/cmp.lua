return {
	"saghen/blink.cmp",

	version = "*",

	opts = {
		keymap = { preset = "default" },

		appearance = {
			nerd_font_variant = "normal",
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "buffer" },
		},
	},
	opts_extend = { "sources.default" },
}
