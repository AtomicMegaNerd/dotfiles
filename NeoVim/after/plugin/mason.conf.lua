local mason_status, mason = pcall(require, "mason")
if not mason_status then
  return
end

local mason_lsp_status, mason_lsp = pcall(require, "mason-lspconfig")
if not mason_lsp_status then
  return
end

mason.setup()
mason_lsp.setup()
