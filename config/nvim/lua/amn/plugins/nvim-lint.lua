return {
	"mfussenegger/nvim-lint",
	config = function()
		local utils = require("amn.utils")
		local lint = utils.do_import("lint")
		if not lint then
			return
		end

		lint.linters_by_ft = {
			go = { "golangcilint" },
			markdown = { "markdownlint" },
		}

		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
