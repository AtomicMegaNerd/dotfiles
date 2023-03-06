local status, telescope = pcall(require, "telescope")
if not status then
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

-- Don't use fzf on Windows
if vim.fn.has("win32") ~= 1 then
	telescope.load_extension("fzf")
end

telescope.load_extension("file_browser")
telescope.load_extension("ui-select")
