--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--

-- Install packer
----------------------------------------------------------------
-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- Run PackerSync when we save this file
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

return packer.startup({
	function(use)
		-- Package manager
		use("wbthomason/packer.nvim")
		-- -- Start-up screen for Neovim
		use({
			"goolord/alpha-nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
		})
		-- -- Telescope
		-- Don't use fzf on Windows
		if vim.fn.has("win32") ~= 1 then
			use({
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
			})
		end
		use({ "nvim-telescope/telescope-file-browser.nvim" })
		use({ "nvim-telescope/telescope-ui-select.nvim" })
		use({
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			requires = { "nvim-lua/plenary.nvim" },
		})
		-- -- Best theme ever
		use("EdenEast/nightfox.nvim")
		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		})
		use({
			"ray-x/lsp_signature.nvim",
		})
		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			tag = "v0.8.5.2",
			run = ":TSUpdate",
		})
		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		})
		-- LSP
		use({
			"neovim/nvim-lspconfig",
		})
		-- Display LSP status
		use("j-hui/fidget.nvim")
		-- CMP
		use({
			"hrsh7th/nvim-cmp",
		})
		-- CMP extensions
		use("hrsh7th/vim-vsnip")
		use("hrsh7th/cmp-vsnip")
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-buffer")
		use("onsails/lspkind.nvim")

		-- Status line
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})

		use("akinsho/toggleterm.nvim")

		-- Rust
		use("simrat39/rust-tools.nvim")

		-- Automatic toggling of comments
		use({
			"numToStr/Comment.nvim",
			tag = "v0.7.0",
		})

		-- Highlight TODO, FIXME, etc.
		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
		})

		-- Managing Git Conflicts
		use({ "akinsho/git-conflict.nvim" })

		-- Make Nvim window transparent
		use({ "xiyaowong/nvim-transparent" })

		-- Helper to find keys and commands
		use({ "folke/which-key.nvim" })

		-- The last few to use vimscript instead of Lua.
		use("tpope/vim-eunuch")
		use("tpope/vim-fugitive")
		use("vim-test/vim-test")
		use("airblade/vim-rooter")

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	},
})
