return {
	"goolord/alpha-nvim",
	priority = 100,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local utils = require("amn.utils")

		local alpha = utils.do_import("alpha")
		if not alpha then
			return
		end

		local startify = utils.do_import("alpha.themes.startify")
		if not startify then
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

		alpha.setup(startify.config)
	end,
}
