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

-- TextYank
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

-- Options for specific Filetypes
----------------------------------------------------------------
local fto_grp = vim.api.nvim_create_augroup("FileTypeOptions", { clear = true })
vim.api.nvim_create_autocmd("Filetype", {
	command = "set tabstop=2 shiftwidth=2",
	group = fto_grp,
	pattern = { "haskell", "lua", "typescript", "tsx", "jsx", "javascript" },
})

vim.api.nvim_create_autocmd("Filetype", {
	command = "set colorcolumn=88",
	group = fto_grp,
	pattern = { "python" },
})
