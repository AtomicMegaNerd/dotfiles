return {
	"goolord/alpha-nvim",
	priority = 100,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local sstatus, startify = pcall(require, "alpha.themes.startify")
		if not sstatus then
			vim.notify("Cannot load alpha.themes.startify", vim.log.levels.ERROR)
			return
		end
		startify.section.header.val = {
			[[     ___   __                  _      __  ___                 _   __              __]],
			[[    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /]],
			[[   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /]],
			[[  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /]],
			[[ /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/]],
			[[                                              /____/]],
		}

		local astatus, alpha = pcall(require, "alpha")
		if not astatus then
			vim.notify("Cannot load alpha", vim.log.levels.ERROR)
			return
		end
		alpha.setup(startify.config)
	end,
}
