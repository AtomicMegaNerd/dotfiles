local c_stat, chat = pcall(require, "CopilotChat")
if not c_stat then
	vim.notify("Cannot load CopilotChat.nvim", vim.log.levels.ERROR)
	return
end

local s_stat, select = pcall(require, "CopilotChat.select")
if not s_stat then
	vim.notify("Cannot load CopilotChat.select", vim.log.levels.ERROR)
	return
end

local cmp_stat, chat_cmp = pcall(require, "CopilotChat.integrations.cmp")
if not cmp_stat then
	vim.notify("Cannot load CopilotChat.cmp", vim.log.levels.ERROR)
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

vim.set.keymap("n", "<leader>pc", function()
	chat.open()
end, "Co[P]ilot [C]hat")

vim.set.keymap("n", "<leader>pt", function()
	chat.toggle()
end, "Co[P]ilot [T]oggle")

vim.set.keymap("n", "<leader>pf", function()
	chat.float()
end, "Co[P]ilot [F]loat")

vim.set.keymap("n", "<leader>pbe", function()
	chat.ask("Please explain how this works", { selection = select.buffer })
end, "Co[P]ilot [B]uffer [E]xplain")
vim.set.keymap("v", "<leader>pbe", function()
	chat.ask("Please explain how this works", { selection = select.buffer })
end, "Co[P]ilot [B]uffer [E]xplain")

vim.set.keymap("v", "<leader>pse", function()
	chat.ask("Please explain how this works", { selection = select.visual })
end, "Co[P]ilot [S]election [E]xplain")

vim.set.keymap("n", "<leader>pob", function()
	chat.ask("Please optimize this code", { selection = select.buffer })
end, "Co[P]ilot [O]ptimize [B]uffer")
vim.set.keymap("v", "<leader>pob", function()
	chat.ask("Please optimize this code", { selection = select.buffer })
end, "Co[P]ilot [O]ptimize [B]uffer")

vim.set.keymap("v", "<leader>pos", function()
	chat.ask("Please optimize this code", { selection = select.visual })
end, "Co[P]ilot [O]ptimize [S]election")

local chat_grp = vim.api.nvim_create_augroup("CopilotChat", { clear = true })
vim.api.nvim_create_autocmd("BuffEnter", {
	pattern = "copilot-*",
	group = chat_grp,
	callback = function()
		vim.opt_local.relativenumber = true
		vim.bo.filetype = "markdown"
	end,
})
