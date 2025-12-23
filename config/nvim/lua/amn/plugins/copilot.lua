return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = true,
			-- This disables the automatic suggestion popup, use <M-Tab> to trigger and
			-- <Tab> to accept
			auto_trigger = false,
			trigger_on_accept = true,
			keymap = {
				accept = "<Tab>",
				accept_word = false,
				accept_line = false,
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-c>",
			},
		},
		panel = { enabled = false },
	},
	-- Set comment highlight for copilot suggestions
	config = function(_, opts)
		local utils = require("amn.utils")
		local copilot = utils.do_import("copilot")
		if not copilot then
			return
		end
		copilot.setup(opts)
		vim.api.nvim_set_hl(0, "CopilotSuggestion", { link = "Comment" })
	end,
}
