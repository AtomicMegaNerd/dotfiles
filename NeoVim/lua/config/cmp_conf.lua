-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	}),
	view = {
		entries = "native",
	},
	sources = {
		-- The order does matter here.  These are ordered
		-- by priority.
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
	},
})