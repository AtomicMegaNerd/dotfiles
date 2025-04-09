return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local utils = require("amn.utils")
		local fzf_lua = utils.do_import("fzf-lua")

		if not fzf_lua then
			return
		end

		fzf_lua.setup({
			-- Basic Keybindings
			utils.nmap("<leader>ff", fzf_lua.files, "[F]ind [F]iles"),
			utils.nmap("<leader>fb", fzf_lua.buffers, "[F]ind [B]uffers"),
			utils.nmap("<leader>fd", fzf_lua.diagnostics_document, "[F]ind Document [d]iagnostics"),
			utils.nmap("<leader>fD", fzf_lua.diagnostics_workspace, "[F]ind Workspace [D]iagnostics"),
			utils.nmap("<leader>fl", fzf_lua.live_grep, "[F]ind [L]ive grep"),

			-- Keybindings for git commands
			utils.nmap("<leader>fgf", fzf_lua.git_files, "[F]ind [G]it files"),
			utils.nmap("<leader>fgs", fzf_lua.git_status, "[F]ind [G]it [S]tatus"),
			utils.nmap("<leader>fgc", fzf_lua.git_commits, "[F]ind [G]it [C]ommits"),
			utils.nmap("<leader>fgb", fzf_lua.git_branches, "[F]ind [G]it [B]ranches"),

			-- Keybindings for general Neovim
			utils.nmap("<leader>fh", fzf_lua.help_tags, "[F]ind [H]elp tags"),
			utils.nmap("<leader>fc", fzf_lua.commands, "[F]ind [C]ommands"),
			utils.nmap("<leader>fk", fzf_lua.keymaps, "[F]ind [K]eymaps"),

			-- Keybindings for LSP
			utils.nmap("<leader>fs", fzf_lua.lsp_document_symbols, "[F]ind [S]ymbols"),
			utils.nmap("<leader>fw", fzf_lua.lsp_workspace_symbols, "[F]ind [W]orkspace symbols"),
			utils.nmap("<leader>fr", fzf_lua.lsp_references, "[F]ind [R]eferences"),
		})

		-- Use fzf-lua as the default ui selector
		fzf_lua.register_ui_select()
	end,
}
