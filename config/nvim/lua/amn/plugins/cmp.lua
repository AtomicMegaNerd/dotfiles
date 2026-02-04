return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = { "fang2hou/blink-copilot" },
	opts = {
		appearance = {
			nerd_font_variant = "normal",
		},
		keymap = { preset = "enter" },
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
		},
		sources = {
			default = { "lsp", "copilot", "path", "buffer" },
			providers = {
				lsp = {
					score_offset = 10,
				},
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					async = true,
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					fallbacks = { "lsp" },
				},
			},
		},
		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
