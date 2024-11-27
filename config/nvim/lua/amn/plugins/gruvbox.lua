if vim.fn.getenv("CLI_THEME") == "gruvbox" then
	return {
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		priority = 1000,
		config = function()
			local utils = require("amn.utils")
			local gruvbox = utils.do_import("gruvbox")

			if not gruvbox then
				return
			end

			gruvbox.setup({
				contrast = "soft",
				italic = {
					strings = false,
					emphasis = false,
					comments = false,
					operators = false,
					folds = true,
				},
			})

			vim.cmd.colorscheme("gruvbox")
		end,
	}
else
	return {}
end
