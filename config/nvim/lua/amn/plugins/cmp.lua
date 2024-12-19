return {
	"saghen/blink.cmp",

	version = "v0.*",
	opts = {
		keymap = { preset = "default" },

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		sources = {
			default = { "lsp", "path", "buffer" },
		},

		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
