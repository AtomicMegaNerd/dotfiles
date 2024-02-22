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
	config = function()
		local utils = require("amn.utils")
		if not utils then
			vim.notify("Utils not found", vim.log.levels.ERROR)
			return
		end

		local telescope = utils.do_import("telescope")
		if not telescope then
			return
		end

		local tb = utils.do_import("telescope.builtin")
		if not tb then
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

		local tfb = telescope.extensions.file_browser.file_browser

		utils.nmap("<leader>ff", tb.find_files, "[F]ind [F]files", "Telescope")
		utils.nmap("<leader>fb", tb.buffers, "[F]ind [B]uffers", "Telescope")
		utils.nmap("<leader>fd", tb.diagnostics, "[F]ind [D]iagnostics", "Telescope")
		utils.nmap("<leader>fl", tb.live_grep, "[F]ind [L]ive [G]rep", "Telescope")
		-- Git
		utils.nmap("<leader>fg", tb.git_files, "[F]ind [G]it files", "Telescope")
		utils.nmap("<leader>fr", tb.git_branches, "[F]ind Git B[R]anch", "Telescope")
		utils.nmap("<leader>fc", tb.git_commits, "[F]ind Git [C]ommits", "Telescope")
		utils.nmap("<leader>fs", tb.git_status, "[F]ind Git [S]tatus", "Telescope")
		-- Neovim
		utils.nmap("<leader>fh", tb.help_tags, "[F]ind Neovim [H]elp topics", "Telescope")
		utils.nmap("<leader>fm", tb.commands, "[F]ind Neovim Co[M]mands", "Telescope")
		utils.nmap("<leader>fk", tb.keymaps, "[F]ind Neovim [K]eymaps", "Telescope")
		-- Todo Comments
		utils.nmap("<leader>ft", [[<cmd>TodoTelescope<cr>]], "[F]ind [T]odo Comments", "Telescope")
		-- Notifications
		utils.nmap("<leader>fn", function()
			telescope.extensions.notify.notify()
		end, "[F]ind [N]otifications", "Telescope")
		-- File Browser
		utils.nmap("<leader>bf", tfb, "[B]rowse [F]iles", "Telescope")
	end,
}
