-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.api.nvim_exec(
	[[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
	false
)

local function get_config(name)
	return string.format('require("config/%s")', name)
end

local use = require("packer").use
require("packer").startup({
	function()
		use("wbthomason/packer.nvim") -- Package manager

		use("tpope/vim-fugitive") -- Git commands in nvim

		use({
			"goolord/alpha-nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = get_config("alpha_conf"),
		})

		use({
			"nvim-telescope/telescope.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = get_config("telescope"),
		})

		use("EdenEast/nightfox.nvim")

		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = get_config("gitsigns"),
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = get_config("treesitter"),
		})

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			config = get_config("lsp"),
		})

		-- LSP extensions
		use("nvim-lua/lsp_extensions.nvim")

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

		-- Spelling
		use("kamykn/spelunker.vim")

		use("airblade/vim-rooter")

		use("godlygeek/tabular")

		use("dag/vim-fish")

		use("tpope/vim-eunuch")

		use("tpope/vim-commentary")

		use({
			"mhartington/formatter.nvim",
			config = get_config("formatter_conf"),
		})

		use("vim-test/vim-test")

		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
			config = get_config("lualine_conf"),
		})

		use("simrat39/rust-tools.nvim")

		use("mfussenegger/nvim-lint")
	end,
	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	},
})
