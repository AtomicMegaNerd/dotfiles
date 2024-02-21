--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_____/  |/  /__  ____ _____ _/ | / /__  _________/ /
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

local status, lazy = pcall(require, "lazy")
if not status then
	return
end

lazy.setup({
	-- Color scheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("amn.catppuccin")
		end,
	},
	-- LSP Startup information
	{
		"j-hui/fidget.nvim",
		priority = 500,
		config = function()
			require("amn.fidget")
		end,
	},
	-- General vim.notify replacement
	{
		"rcarriga/nvim-notify",
		priority = 101,
		config = function()
			require("amn.nvim-notify")
		end,
	},
	-- Startup screen
	{
		"goolord/alpha-nvim",
		priority = 100,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("amn.alpha")
		end,
	},
	-- Telescope is a fuzzy finder framework for Neovim
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			-- Make Telescope faster
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			-- Browse files
			{ "nvim-telescope/telescope-file-browser.nvim" },
			-- Replace Neovim's built-in select UI
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			require("amn.telescope")
		end,
	},
	-- Treesitter is a parser generator tool and an incremental parsing library
	{
		"nvim-treesitter/nvim-treesitter",
		cmd = "TSUpdate",
		config = function()
			require("amn.treesitter")
		end,
	},
	-- Git information in the gutter
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("amn.gitsigns")
		end,
	},
	-- Git commands in Neovim
	"tpope/vim-fugitive",
	-- LSP
	"neovim/nvim-lspconfig",
	"ray-x/lsp_signature.nvim",
	{
		"folke/neodev.nvim",
		config = function()
			require("amn.neodev")
		end,
	},
	-- Mason is for installing LSP's, linters, and formatters
	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("amn.mason")
		end,
	},
	-- Auto-completion for Neovim
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"onsails/lspkind.nvim", -- Add vscode-like pictograms to neovim built-in LSP
		},
		config = function()
			require("amn.cmp")
		end,
	},
	-- Unit test framework
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-go",
		},
		config = function()
			require("amn.neotest")
		end,
	},
	-- Status Line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("amn.lualine")
		end,
	},
	-- Code Comments
	{
		"numToStr/Comment.nvim",
		config = function()
			require("amn.comment")
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("amn.todo")
		end,
	},
	-- Formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("amn.conform")
		end,
	},
	-- Misc
	{
		"folke/which-key.nvim",
		config = function()
			require("amn.which-key")
		end,
	},
	-- vim-rooter changes the working directory to the project root
	"airblade/vim-rooter",
	-- Robot helping me with my code
	"github/copilot.vim",
})
