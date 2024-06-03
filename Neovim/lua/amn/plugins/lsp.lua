return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"ray-x/lsp_signature.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local utils = require("amn.utils")

		local nvim_lsp = utils.do_import("lspconfig")
		if not nvim_lsp then
			return
		end

		local lsp_signature = utils.do_import("lsp_signature")
		if not lsp_signature then
			return
		end

		local cmp_nvim_lsp = utils.do_import("cmp_nvim_lsp")
		if not cmp_nvim_lsp then
			return
		end

		local telescope_builtin = utils.do_import("telescope.builtin")
		if not telescope_builtin then
			return
		end

		-- Disable the panda
		lsp_signature.setup({
			hint_prefix = "> ",
		})

		local on_attach = function(_, bufnr)
			utils.nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame", "LSP", bufnr)
			utils.nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", "LSP", bufnr)
			utils.nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition", "LSP", bufnr)
			utils.nmap("gl", vim.lsp.buf.declaration, "[G]oto [D]eclaration", "LSP", bufnr)
			utils.nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation", "LSP", bufnr)
			utils.nmap("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences", "LSP", bufnr)
			utils.nmap("gt", vim.lsp.buf.type_definition, "Type [D]efinition", "LSP", bufnr)
			utils.nmap("K", vim.lsp.buf.hover, "Hover Documentation", "LSP", bufnr)
			utils.nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation", "LSP", bufnr)
		end

		local capabilities = cmp_nvim_lsp.default_capabilities()

		local servers = {
			"pyright",
			"ruff",
			"bashls",
			"gopls",
		}

		for _, lsp in ipairs(servers) do
			nvim_lsp[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		nvim_lsp.yamlls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				yaml = {
					keyOrdering = false,
				},
			},
		})

		-- Make sure we suppress warnings on the vim global object
		nvim_lsp.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
				telemetry = { enable = false },
			},
		})
	end,
}
