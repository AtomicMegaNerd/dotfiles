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
		-- calling `setup` is optional for customization
		fzf_lua.setup({
			utils.nmap("<leader>ff", fzf_lua.files, "[F]ind [F]iles"),
			utils.nmap("<leader>fb", fzf_lua.buffers, "[F]ind [B]uffers"),
			utils.nmap("<leader>fd", fzf_lua.diagnostics_document, "[F]ind [D]iagnostics"),
		})
	end,
}
