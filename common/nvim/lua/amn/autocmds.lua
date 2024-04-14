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
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
	group = fmt_grp,
})

-- Options for specific file types
----------------------------------------------------------------
local fto_grp = vim.api.nvim_create_augroup("FileTypeOptions", { clear = true })
vim.api.nvim_create_autocmd("Filetype", {
	command = "set tabstop=2 shiftwidth=2",
	group = fto_grp,
	pattern = { "haskell", "lua", "typescript", "tsx", "jsx", "javascript", "nix" },
})

vim.api.nvim_create_autocmd("Filetype", {
	command = "set colorcolumn=88",
	group = fto_grp,
	pattern = { "python" },
})

-- Set copilot-chat as markdown filetype
vim.api.nvim_create_autocmd("Filetype", {
	command = "set filetype=markdown",
	group = fto_grp,
	pattern = { "copilot-chat" },
})

-- Always open new windows on the right
vim.api.nvim_create_autocmd("BufWinEnter", {
	command = "wincmd L",
	group = fto_grp,
})

vim.filetype.add({
	pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

vim.filetype.add({
	pattern = { [".*/waybar/config"] = "json" },
})
