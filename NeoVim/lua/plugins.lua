--     ___   __                  _      __  ___                 _   __              __
--    /   | / /_____  ____ ___  (_)____/  |/  /__  ____ _____ _/ | / /__  _________/ /
--   / /| |/ __/ __ \/ __ `__ \/ / ___/ /|_/ / _ \/ __ `/ __ `/  |/ / _ \/ ___/ __  /
--  / ___ / /_/ /_/ / / / / / / / /__/ /  / /  __/ /_/ / /_/ / /|  /  __/ /  / /_/ /
-- /_/  |_\__/\____/_/ /_/ /_/_/\___/_/  /_/\___/\__, /\__,_/_/ |_/\___/_/   \__,_/
--                                              /____/
--

-- Install packer
----------------------------------------------------------------
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

local function get_config(name)
	return string.format('require("config/%s")', name)
end

local use = require("packer").use

require("packer").startup({
	function()
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
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			requires = { "nvim-lua/plenary.nvim" },
			config = get_config("telescope_conf"),
		})
		use({
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
			cond = vim.fn.executable("make") == 1,
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

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			config = get_config("lsp_conf"),
		})

		-- LSP extensions
		use("nvim-lua/lsp_extensions.nvim")

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
		use("ray-x/lsp_signature.nvim")

		-- Automatic formatting
		use({
			"mhartington/formatter.nvim",
			config = get_config("formatter_conf"),
		})

		-- Status line
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
			config = get_config("lualine_conf"),
		})

		-- Rust
		use("simrat39/rust-tools.nvim")

		-- Linting
		use({
			"mfussenegger/nvim-lint",
			config = get_config("lint_conf"),
		})

		-- Automatic toggling of comments
		use({
			"numToStr/Comment.nvim",
			tag = "v0.6.1",
			config = get_config("comment_conf"),
		})

		use({ "akinsho/git-conflict.nvim", config = get_config("gitconflict_conf") })

		-- The last few to use vimscript instead of Lua.
		use("tpope/vim-eunuch")
		use("tpope/vim-fugitive")
		use("vim-test/vim-test")
		use("airblade/vim-rooter")
		-- Still the best spelling plug-in
		use("kamykn/spelunker.vim")
	end,
	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	},
})
