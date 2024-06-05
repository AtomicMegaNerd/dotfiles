return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
		},
		event = "VeryLazy",
		config = function()
			local utils = require("amn.utils")
			local chat = utils.do_import("CopilotChat")
			if not chat then
				return vim.notify("CopilotChat not found", vim.log.levels.ERROR)
			end

			local select = utils.do_import("CopilotChat.select")
			if not select then
				vim.notify("CopilotChat.select not found", vim.log.levels.ERROR)
				return
			end

			local chat_cmp = utils.do_import("CopilotChat.integrations.cmp")
			if not chat_cmp then
				vim.notify("CopilotChat.cmp not found", vim.log.levels.ERROR)
				return
			end

			chat_cmp.setup()
			chat.setup({
				show_help = false,
				context = "buffers",
				mappings = {
					complete = {
						insert = "",
					},
				},
			})

			utils.nmap("<leader>pc", function()
				chat.open()
			end, "Co[P]ilot [C]hat")

			utils.nmap("<leader>pt", function()
				chat.toggle()
			end, "Co[P]ilot [T]oggle")

			utils.nmap("<leader>pf", function()
				chat.open({ window = { layout = "float" } })
			end, "Co[P]ilot [F]loat")

			utils.nmap("<leader>pb", function()
				chat.ask("Please Explain how this works", { selection = select.buffer })
			end, "Co[P]ilot [B]uffer explain")
			utils.vmap("<leader>pb", function()
				chat.ask("Please Explain how this works", { selection = select.buffer })
			end, "Co[P]ilot [B]uffer explain")

			utils.vmap("<leader>ps", function()
				chat.ask("Please explain how this works", { selection = select.visual })
			end, "Co[P]ilot [S]election explain")

			-- Turn on relative numbers when entering a copilot buffer and set filetype to
			-- Markdown
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.bo.filetype = "markdown"
				end,
			})
		end,
	},
}
