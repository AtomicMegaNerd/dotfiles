-- Text yank
----------------------------------------------------------------
-- Automatically highlight text when we yank it
local yank_grp = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = yank_grp,
	pattern = "*",
})

-- Options for specific file types
----------------------------------------------------------------
local fto_grp = vim.api.nvim_create_augroup("FileTypeOptions", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	command = "set tabstop=2 shiftwidth=2",
	group = fto_grp,
	pattern = { "haskell", "lua", "typescript", "javascript", "terraform", "nix", "markdown" },
})

vim.api.nvim_create_autocmd("Filetype", {
	command = "set noexpandtab",
	group = fto_grp,
	pattern = { "bash", "sh", "go" },
})

vim.api.nvim_create_autocmd("Filetype", {
	command = "set colorcolumn=88",
	group = fto_grp,
	pattern = { "python" },
})

vim.api.nvim_create_autocmd("Filetype", {
	command = "set colorcolumn=100",
	group = fto_grp,
	pattern = {
		"go",
		"yaml",
		"markdown",
		"json",
		"sh",
		"bash",
		"nix",
		"lua",
		"typescript",
		"javascript",
		"haskell",
		"terraform",
	},
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	command = "setf sh",
	group = fto_grp,
	pattern = { "env.list", ".envrc" },
})
