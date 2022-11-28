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

local function get_config(name)
	return string.format('require("config/%s")', name)
end

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

return packer.startup({
	function(use)
		-- Package manager
		use("wbthomason/packer.nvim")

		-- Start-up screen for Neovim
		use({
			"goolord/alpha-nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = get_config("alpha_conf"),
		})

		-- Telescope
		use({
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
		})
		use({ "nvim-telescope/telescope-file-browser.nvim" })
		use({ "nvim-telescope/telescope-ui-select.nvim" })
		use({
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			requires = { "nvim-lua/plenary.nvim" },
			config = get_config("telescope_conf"),
		})

		-- Best theme ever
		use("EdenEast/nightfox.nvim")

		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = get_config("gitsigns_conf"),
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = get_config("treesitter_conf"),
		})

		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		})

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			config = get_config("lsp_conf"),
		})

		-- LSP Kind
		use("onsails/lspkind.nvim")

		-- LSP and Linters Installer
		use({
			"williamboman/mason.nvim",
			config = get_config("mason_conf"),
		})
		use("williamboman/mason-lspconfig.nvim")

		-- CMP
		use({
			"hrsh7th/nvim-cmp",
			config = get_config("cmp_conf"),
		})

		-- CMP extensions
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-buffer")
		use("saadparwaiz1/cmp_luasnip")
		use("L3MON4D3/LuaSnip")
		use("onsails/lspkind.nvim")

		-- Status line
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
			config = get_config("lualine_conf"),
		})

		-- Rust
		use("simrat39/rust-tools.nvim")

		-- Automatic toggling of comments
		use({
			"numToStr/Comment.nvim",
			tag = "v0.7.0",
			config = get_config("comment_conf"),
		})

		-- Highlight TODO, FIXME, etc.
		use({
			"folke/todo-comments.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = get_config("todo_conf"),
		})

		-- Managing Git Conflicts
		use({ "akinsho/git-conflict.nvim", config = get_config("gitconflict_conf") })

		-- Make Nvim window transparent
		use({ "xiyaowong/nvim-transparent", config = get_config("transparent_conf") })

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
