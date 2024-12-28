return {
	"github/copilot.vim",
	init = function()
		vim.g.copilot_enabled = false

		local utils = require("amn.utils")

		local function enable_copilot()
			vim.cmd("Copilot enable")
			vim.notify("Copilot enabled", vim.log.levels.INFO)
		end

		local function disable_copilot()
			vim.cmd("Copilot disable")
			vim.notify("Copilot disabled", vim.log.levels.INFO)
		end

		utils.nmap("<leader>pe", enable_copilot, "Co-[P]ilot [E]nabled")
		utils.nmap("<leader>pd", disable_copilot, "Co-[P]ilot [D]isabled")
	end,
}
