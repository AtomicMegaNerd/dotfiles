return {
	"saghen/blink.cmp",
	version = "*",
	opts = {
		keymap = { preset = "enter" },
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "buffer" },
		},
		signature = { enabled = true },
		completion = {
			menu = {
				auto_show = function(ctx)
					return ctx.mode ~= "cmdline"
				end,
			},
		},
	},
	opts_extend = { "sources.default" },
}
