return {
  "neovim/nvim-lspconfig",

  config = function()
    local utils = require("amn.utils")
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        utils.nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame", "LSP", args.buf)
        utils.nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", "LSP", args.buf)
        utils.nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition", "LSP", args.buf)
        utils.nmap("gl", vim.lsp.buf.declaration, "[G]oto [D]eclaration", "LSP", args.buf)
        utils.nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation", "LSP", args.buf)
        utils.nmap("gt", vim.lsp.buf.type_definition, "Type [D]efinition", "LSP", args.buf)
        utils.nmap("K", vim.lsp.buf.hover, "Hover Documentation", "LSP", args.buf)
        utils.nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation", "LSP", args.buf)
        utils.nmap("<leader>td",
          function()
            local current = vim.diagnostic.config().virtual_text
            vim.diagnostic.config({ virtual_text = not current })
          end,
          "[T]oggle [D]iagnostics", "LSP",
          args.buf)
      end,
    })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          keyOrdering = false,
        },
      },
    })

    vim.lsp.config("pyright", {
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

    local servers = {
      "ruff",
      "nil_ls",
      "bashls",
      "gopls",
      "dockerls",
      "rust_analyzer",
      "lua_ls",
      "yamlls",
      "pyright",
    }

    for _, lsp in ipairs(servers) do
      vim.lsp.enable(lsp)
    end
  end,
}
