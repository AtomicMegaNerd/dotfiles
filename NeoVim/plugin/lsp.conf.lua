-- LSP settings
--

local lspconfig_status, nvim_lsp = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local null_ls_status, null_ls = pcall(require, "null-ls")
if not null_ls_status then
	return
end

local tele_builtin_status, telescope_builtin = pcall(require, "telescope.builtin")
if not tele_builtin_status then
	return
end

local rust_tools_status, rust_tools = pcall(require, "rust-tools")
if not rust_tools_status then
	return
end

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gr", telescope_builtin.lsp_references)
	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end,
		})
	end
end

-- nvim-cmp supports additional completion capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Enable the following language servers
local servers = { "gopls", "yamlls", "bashls", "hls", "pyright", "rnix", "ruff_lsp" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" },
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

-- Rust tools embeds the rust-analyzer server, but we want to make sure we pass
-- our key-bindings to this server so things like rename work.
rust_tools.setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {

			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
})

null_ls.setup({
	sources = {
		-- Formatters
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.nixpkgs_fmt,

		-- Diagnostics
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.diagnostics.staticcheck,
		null_ls.builtins.diagnostics.pylint,
	},
	on_attach = on_attach,
	capabilities = capabilities,
})
