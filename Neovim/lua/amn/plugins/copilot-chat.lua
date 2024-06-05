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

			local chat_select = utils.do_import("CopilotChat.select")
			if not chat_select then
				vim.notify("CopilotChat.select not found", vim.log.levels.ERROR)
				return
			end

			local chat_actions = utils.do_import("CopilotChat.actions")
			if not chat_actions then
				vim.notify("CopilotChat.actions not found", vim.log.levels.ERROR)
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

			utils.nmap("<leader>cc", function()
				chat.open()
			end, "[C]opilit [C]hat")

			utils.nmap("<leader>cct", function()
				chat.toggle()
			end, "[C]opilit [C]hat [T]oggle")

			utils.nmap("<leader>ccf", function()
				chat.open({ window = { layout = "float" } })
			end, "[C]opilit [C]hat [F]loat")

			utils.vmap("<leader>ccs", function()
				chat.ask("Please Explain how this works", { selection = chat_select.buffer })
			end, "[C]opilit [C]hat explain [B]uffer")

			utils.vmap("<leader>ccs", function()
				chat.ask("Please explain how this works", { selection = chat_select.selection })
			end, "[C]opilit [C]hat explain [S]election")

			utils.nmap("<leader>cca", function()
				chat_actions.pick(chat.prompt_actions({
					selection = chat_select.visual,
				}))
			end, "[C]opilit [C]hat [A]ctions")

			-- Turn on relative numbers when entering a copilot buffer
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
				end,
			})
		end,
	},
}
