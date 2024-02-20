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
  -- Always load the color scheme first
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "j-hui/fidget.nvim",
    priority = 500,
  },
  {
    "rcarriga/nvim-notify",
    priority = 100,
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    cmd = "TSUpdate",
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Git
  "tpope/vim-fugitive",
  -- LSP
  "neovim/nvim-lspconfig",
  "ray-x/lsp_signature.nvim",
  "folke/neodev.nvim",
  -- Mason
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "onsails/lspkind.nvim",
    },
  },
  -- Unit tests
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
    },
  },
  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- Code Comments
  "numToStr/Comment.nvim",
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- Formatting
  "stevearc/conform.nvim",
  -- Misc
  "folke/which-key.nvim",
  "airblade/vim-rooter",
  "github/copilot.vim",
})
