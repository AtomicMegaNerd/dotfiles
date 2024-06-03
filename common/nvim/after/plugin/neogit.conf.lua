local status, neogit = pcall(require, "neogit")
if not status then
	vim.notify("Cannot load neogit.nvim", vim.log.levels.ERROR)
	return
end

neogit.setup({

	integrations = {
		diffview = true,
		telescope = true,
		fzf_lua = true,
	},
})

vim.keymap.set("n", "<leader>ng", neogit.open, { desc = "Open [N]eo[g]it" })
