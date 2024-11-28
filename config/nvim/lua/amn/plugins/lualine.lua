local get_theme = function()
	local cli_theme = vim.fn.getenv("CLI_THEME")
	if cli_theme == "gruvbox" then
		return "gruvbox"
	end
	if cli_theme == "catppuccin" then
		return "catppuccin"
	end
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local utils = require("amn.utils")
		local lualine = utils.do_import("lualine")

		if not lualine then
			return
		end

		lualine.setup({
			options = {
				theme = get_theme(),
				icons_enabled = false,
				globalstatus = true,
			},
			extensions = { "fugitive" },
		})
	end,
}
