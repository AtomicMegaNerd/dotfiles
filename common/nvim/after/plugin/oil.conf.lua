local status, oil = pcall(require, "oil")
if not status then
	vim.notify("Cannot load oil.nvim", vim.log.levels.ERROR)
	return
end

oil.setup()

-- Keybindings for Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<space>-", require("oil").toggle_float)
