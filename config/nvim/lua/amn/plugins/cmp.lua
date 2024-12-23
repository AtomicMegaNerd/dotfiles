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
	},

	signature = { enabled = true },
}
