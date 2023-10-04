-- Packer
----------------------------------------------------------------

-- Automatically source and re-compile packer whenever you save plugins.lua or init.lua. This
-- only applies to non-Nix configurations. On nix managed systems we simply use nix to manage
-- the packages and packer isn't even installed.
local install_type = os.getenv("AMN_INSTALL_TYPE")
if install_type ~= nil and install_type == "non-nix" then
	local pack_grp = vim.api.nvim_create_augroup("Packer", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		command = "source <afile> | PackerCompile",
		group = pack_grp,
		pattern = { "init.lua", "plugins.lua" },
	})
end

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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	command = "setf yaml",
	group = fto_grp,
	pattern = "*/yamllint/config",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	command = "setf json",
	group = fto_grp,
	pattern = "*/waybar/config",
})
