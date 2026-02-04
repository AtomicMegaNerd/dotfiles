return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		suggestion = { enabled = false },
		panel = { enabled = false },
	},
	config = function(_, opts)
		local utils = require("amn.utils")
		local copilot = utils.do_import("copilot")
		if not copilot then
			return
		end
		copilot.setup(opts)
	end,
}
