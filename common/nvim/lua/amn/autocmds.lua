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

-- Formatting
----------------------------------------------------------------
local fmt_grp = vim.api.nvim_create_augroup("FormatOptions", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "FormatWrite",
	group = fmt_grp,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format()
	end,
  group = fmt_grp,
})

-- Options for specific file types
----------------------------------------------------------------
local fto_grp = vim.api.nvim_create_augroup("FileTypeOptions", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	command = "set tabstop=2 shiftwidth=2",
	group = fto_grp,
	pattern = { "haskell", "lua", "typescript", "tsx", "jsx", "javascript", "terraform", "nix" },
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

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	command = "setf groovy",
	group = fto_grp,
	pattern = "Jenkinsfile",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	command = "setf sh",
	group = fto_grp,
	pattern = "env.list",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	command = "setf json",
	group = fto_grp,
	pattern = "*/waybar/config",
})
