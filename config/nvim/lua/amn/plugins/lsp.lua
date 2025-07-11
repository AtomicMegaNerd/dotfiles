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
      utils.nmap("<leader>td", function()
        local current = vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = not current })
      end, "[T]oggle [D]iagnostics", "LSP", bufnr)
    end

    local servers = {
      "ruff",
      "nil_ls",
      "bashls",
      "gopls",
      "dockerls",
      "rust_analyzer",
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

    nvim_lsp.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            ignore = { "*" },
          },
        },
      },
    })

    -- Make sure we suppress warnings on the vim global object
    nvim_lsp.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        telemetry = { enable = false },
      },
    })
  end,
}
