return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-go",
	},
	config = function()
		local utils = require("amn.utils")
		local nt = utils.do_import("neotest")
		if not nt then
			return
		end

		local nt_pytest = utils.do_import("neotest-python")
		if not nt_pytest then
			return
		end

		local nt_go = utils.do_import("neotest-go")
		if not nt_go then
			return
		end

		nt.setup({
			adapters = {
				nt_pytest({}),
				nt_go({}),
			},
		})

		vim.g["test#strategy"] = "neovim"

		utils.nmap("<leader>tn", function()
			nt.run.run()
			nt.output.open()
			nt.summary.open()
		end, "Run [T]est [N]earest to cursor")

		utils.nmap("<leader>tf", function()
			nt.run.run(vim.fn.expand("%"))
			nt.output.open()
			nt.summary.open()
		end, "Run all [T]ests in [F]ile")

		utils.nmap("<leader>ts", function()
			nt.run.run(vim.fn.getcwd())
			nt.output.open()
			nt.summary.open()
		end, "Run whole [T]est [S]uite")
	end,
}
