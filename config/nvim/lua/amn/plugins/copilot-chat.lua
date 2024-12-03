return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	dependencies = {
		"github/copilot.vim",
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	config = function()
		local utils = require("amn.utils")
		local chat = utils.do_import("CopilotChat")
		local select = utils.do_import("CopilotChat.select")

		if not chat or not select then
			return
		end

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
			chat.open({
				window = {
					title = "Co-Pilot Chat",
					layout = "replace",
				},
			})
			-- This ensures that the buffer shows up in the buffer list
			vim.cmd("setlocal buflisted")
		end, "Co[P]ilot [C]hat")

		utils.nmap("<leader>pt", function()
			chat.toggle()
		end, "Co[P]ilot [T]oggle")

		utils.nmap("<leader>pf", function()
			chat.open({
				window = {
					title = "Co-Pilot Chat",
					layout = "float",
				},
			})
		end, "Co[P]ilot [F]loat")

		utils.nvmap("<leader>pbe", function()
			chat.ask("Please explain how this works", { selection = select.buffer })
		end, "Co[P]ilot [B]uffer [E]xplain")

		utils.vmap("<leader>pse", function()
			chat.ask("Please explain how this works", { selection = select.visual })
		end, "Co[P]ilot [S]election [E]xplain")

		utils.nvmap("<leader>pob", function()
			chat.ask("Please optimize this code", { selection = select.buffer })
		end, "Co[P]ilot [O]ptimize [B]uffer")

		utils.vmap("<leader>pos", function()
			chat.ask("Please optimize this code", { selection = select.visual })
		end, "Co[P]ilot [O]ptimize [S]election")

		local chat_grp = vim.api.nvim_create_augroup("CopilotChat", { clear = true })
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-chat",
			group = chat_grp,
			callback = function()
				vim.opt_local.relativenumber = true
				vim.bo.filetype = "markdown"
			end,
		})
	end,
}
