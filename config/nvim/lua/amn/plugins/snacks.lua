return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		indent = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		rename = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },

		dashboard = {
			sections = {
				{ section = "header" },
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},
	},
}
