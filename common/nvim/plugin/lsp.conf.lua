-- LSP settings
--

local lspconfig_status, nvim_lsp = pcall(require, "lspconfig")
if not lspconfig_status then
  vim.notify("Cannot load lspconfig", vim.log.levels.ERROR)
  return
end

local lsp_sig_status, lsp_signature = pcall(require, "lsp_signature")
if not lsp_sig_status then
  vim.notify("Cannot load lsp_signature", vim.log.levels.ERROR)
  return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  vim.notify("Cannot load cmp_nvim_lsp", vim.log.levels.ERROR)
  return
end

local tele_builtin_status, telescope_builtin = pcall(require, "telescope.builtin")
if not tele_builtin_status then
  vim.notify("Cannot load telescope.builtin", vim.log.levels.ERROR)
  return
end

local mason_status, mason = pcall(require, "mason")
if not mason_status then
  vim.notify("Cannot load mason", vim.log.levels.ERROR)
  return
end

local mason_lsp_status, mason_lsp = pcall(require, "mason-lspconfig")
if not mason_lsp_status then
  vim.notify("Cannot load mason-lspconfig", vim.log.levels.ERROR)
  return
end

mason.setup()
mason_lsp.setup()

-- Disable the panda
lsp_signature.setup({
  hint_prefix = "> ",
})

local on_attach = function(_, bufnr)
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
end

-- nvim-cmp supports additional completion capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()

local servers = { "pyright", "rnix", "ruff_lsp", "bashls" }
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

nvim_lsp.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    -- Static analysis linter for Go
    staticcheck = true,
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
