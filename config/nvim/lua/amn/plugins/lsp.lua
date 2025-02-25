return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
	},

	config = function()
		local utils = require("amn.utils")

		local nvim_lsp = utils.do_import("lspconfig")
		local cmp = utils.do_import("blink.cmp")
		if not nvim_lsp or not cmp then
			return
		end

		local capabilities = cmp.get_lsp_capabilities()
		if not capabilities then
			return
		end

		local on_attach = function(_, bufnr)
			utils.nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame", "LSP", bufnr)
			utils.nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", "LSP", bufnr)
			utils.nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition", "LSP", bufnr)
			utils.nmap("gl", vim.lsp.buf.declaration, "[G]oto [D]eclaration", "LSP", bufnr)
			utils.nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation", "LSP", bufnr)
			utils.nmap("gt", vim.lsp.buf.type_definition, "Type [D]efinition", "LSP", bufnr)
			utils.nmap("K", vim.lsp.buf.hover, "Hover Documentation", "LSP", bufnr)
			utils.nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation", "LSP", bufnr)
		end

		local servers = {
			"pyright",
			"nil_ls",
			"ruff",
			"bashls",
			"gopls",
			"ruff",
			"golangci_lint_ls",
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
