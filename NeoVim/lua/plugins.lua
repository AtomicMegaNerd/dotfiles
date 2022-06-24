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
		-- UI to select things (files, grep results, open buffers...)
		use({
			"nvim-telescope/telescope.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = get_config("telescope"),
		})
		use("EdenEast/nightfox.nvim")
		-- Add indentation guides even on blank lines
		use("lukas-reineke/indent-blankline.nvim")
		-- Add git related info in the signs columns and popups
		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = get_config("gitsigns"),
		})
		-- Highlight, edit, and navigate code using a fast incremental parsing library
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = get_config("treesitter"),
		})
		use({
			"neovim/nvim-lspconfig",
			config = get_config("lsp"),
		}) -- Collection of configurations for built-in LSP client
		use("nvim-lua/lsp_extensions.nvim")
		use({
			"hrsh7th/nvim-cmp",
			config = get_config("cmp_conf"),
		}) -- Autocompletion plugin
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-buffer")
		use("saadparwaiz1/cmp_luasnip")
		use("L3MON4D3/LuaSnip") -- Snippets plugin
		use("ray-x/lsp_signature.nvim")

		-- Random collection of the rest
		use("kamykn/spelunker.vim")
		use("mhinz/vim-startify")
		use("airblade/vim-rooter")
		use("godlygeek/tabular")
		use("dag/vim-fish")
		use("tpope/vim-eunuch") -- Git shell wrappers
		use("tpope/vim-commentary")
		use({ "mhartington/formatter.nvim", config = get_config("formatter_conf") })
		use("vim-test/vim-test")
		use({ "nvim-lualine/lualine.nvim", config = get_config("lualine_conf") })
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
