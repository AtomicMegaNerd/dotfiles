local status, copilot_chat = pcall(require, "CopilotChat")
if not status then
	vim.notify("Cannot load CopilotChat.nvim", vim.log.levels.ERROR)
	return
end

copilot_chat.setup({
	show_help = false,
})
