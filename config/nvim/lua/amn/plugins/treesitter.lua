return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		local utils = require("amn.utils")
		local ts = utils.do_import("nvim-treesitter")

		if not ts then
			return
		end

		local langs = {
			"bash",
			"go",
			"json",
			"lua",
			"markdown",
			"python",
			"sql",
			"vim",
			"yaml",
			"toml",
			"nix",
			"diff",
			"gomod",
			"fish",
		}

		ts.install(langs):wait(300000)

		-- Enable highlighting for all specified languages
		local trs_grp = vim.api.nvim_create_augroup("Treesitter", { clear = true })
		for _, lang in ipairs(langs) do
			vim.api.nvim_create_autocmd("FileType", {
				group = trs_grp,
				pattern = lang,
				callback = function()
					vim.treesitter.start()
				end,
			})
		end
	end,
}
