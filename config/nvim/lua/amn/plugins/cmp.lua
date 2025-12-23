return {
	"saghen/blink.cmp",
	version = "1.*",
	opts = {
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "buffer" },
		},
		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
	config = function(_, opts)
		local utils = require("amn.utils")
		local blink = utils.do_import("blink.cmp")
		if blink then
			blink.setup(opts)
		end
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuOpen",
			callback = function()
				vim.b.copilot_suggestion_hidden = true
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuClose",
			callback = function()
				vim.b.copilot_suggestion_hidden = false
			end,
		})
	end,
}
