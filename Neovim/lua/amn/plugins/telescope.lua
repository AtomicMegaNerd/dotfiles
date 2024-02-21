return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		-- Make Telescope faster
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
		-- Browse files
		{ "nvim-telescope/telescope-file-browser.nvim" },
		-- Replace Neovim's built-in select UI
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	lazy = true,
	config = function()
		local status, telescope = pcall(require, "telescope")
		if not status then
			vim.notify("Cannot load telescope", vim.log.levels.ERROR)
			return
		end

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
				prompt_prefix = "> ",
				selection_caret = "> ",
				entry_prefix = "  ",
				initial_mode = "insert",
				selection_strategy = "reset",
				sorting_strategy = "ascending",
				layout_strategy = "flex",
				layout_config = {
					height = 0.9,
					width = 0.9,
					vertical = {
						preview_cutoff = 1,
						preview_height = 0.5,
					},
					horizontal = {
						preview_width = 0.6,
					},
				},
				file_ignore_patterns = { "target", "**.lock", "build", "node_modules" },
			},
			extensions = {
				file_browser = {
					hijack_netrw = true,
					hidden = true,
					respect_gitignore = false,
				},
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")
		telescope.load_extension("ui-select")
	end,
}
