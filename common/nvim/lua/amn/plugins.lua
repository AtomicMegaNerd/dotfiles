--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Start-up screen for Neovim
	{
		"goolord/alpha-nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
	},
	-- Telescope
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim", lazy = true },
	},
	-- Best theme ever
	{ "EdenEast/nightfox.nvim" },
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.9.1",
		cmd = "TSUpdate",
	},
	-- LSP
	{
		"neovim/nvim-lspconfig",
	},
	{
		"ray-x/lsp_signature.nvim",
	},
	-- Display LSP status
	{ "j-hui/fidget.nvim", tag = "legacy" },
	-- CMP
	{
		"hrsh7th/nvim-cmp",
	},
	-- CMP extensions
	{ "hrsh7th/vim-vsnip" },
	{ "hrsh7th/cmp-vsnip" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-buffer" },
	{ "onsails/lspkind.nvim" },

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
	},

	-- Automatic toggling of comments
	{
		"numToStr/Comment.nvim",
		tag = "v0.8.0",
	},

	{ "mhartington/formatter.nvim" },

	-- Highlight TODO, FIXME, etc.
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim", lazy = true },
	},

	-- NeoTest
	{
		"nvim-neotest/neotest",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-python",
		},
	},

	-- Mason
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		cmd = "MasonUpdate", -- MasonUpdate updates registry contents
	},

	-- Which Key
	{ "folke/which-key.nvim", lazy = true },

	-- The last few to use vimscript instead of Lua.
	{ "tpope/vim-fugitive" },
})
