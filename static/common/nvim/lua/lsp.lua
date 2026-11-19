local fzf = require("fzf-lua")
local map = vim.keymap.set

-- LSP's to enable
vim.lsp.enable({
  "bashls",
  "docker_language_server",
  "fish_lsp",
  "gopls",
  "lemminx",
  "marksman",
  "lua_ls",
  "nil_ls",
  "nushell",
  "oxfmt",
  "oxlint",
  "tsc",
  "tombi",
  "yamlls",
  "rust_analyzer",
  "ty",
  "ruff",
})

-- Config Overrides
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        appendclipped = true,
        nilness = true,
        shadow = true,
        simplifyslicing = true,
        slicesdelete = true,
        useany = true,
        unusedvariable = true,
        unusedwrite = true,
      },
      staticcheck = false,
      codelenses = {
        generate = true,
        test = true,
        tidy = true,
        vendor = true,
        upgrade_dependency = true,
        gc_details = true,
      },
      renameMovesSubpackages = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        ignoredError = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.config("nil_ls", {
  settings = {
    ["nil"] = {
      formatter = {
        command = "nixfmt",
      },
      flake = {
        autoArchive = true,
        autoEvalInputs = true,
      },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      keyOrdering = false,
      validate = false,
    },
  },
})

-- This configures the appearance of diagnostics in the buffer
vim.diagnostic.config({
  virtual_lines = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- This function toggles inlay hints. They are disabled by default, but this will toggle them
-- on or off as needed.
local toggle_hints = function(client)
  if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    local enabled = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    vim.lsp.inlay_hint.enable(enabled, { bufnr = 0 })
    if enabled then
      vim.notify("LSP Inlay hints enabled", vim.log.levels.INFO)
    else
      vim.notify("LSP Inlay hints disabled", vim.log.levels.INFO)
    end
  end
end

-- Configure keybindings and features when LSP server is attached to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- General LSP keymaps
    map("n", "<leader>cr", vim.lsp.buf.rename, { buffer = args.buf, desc = "[C]ode [R]ename" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "[C]ode [A]ction" })
    map("n", "<leader>cl", vim.lsp.codelens.run, { buffer = args.buf, desc = "[C]ode [L]ens" })
    map("n", "<leader>ch", function()
      toggle_hints(client)
    end, { buffer = args.buf, desc = "[C]ode Toggle Inlay [H]int" })
    map("n", "gd", fzf.lsp_definitions, { buffer = args.buf, desc = "[G]oto [D]ef" })
    map("n", "gl", fzf.lsp_declarations, { buffer = args.buf, desc = "[G]oto Dec[l]" })
    map("n", "gr", fzf.lsp_references, { buffer = args.buf, desc = "[G]oto [R]efs" })
    map("n", "gi", fzf.lsp_implementations, { buffer = args.buf, desc = "[G]oto [I]mpl" })
    map("n", "gt", fzf.lsp_typedefs, { buffer = args.buf, desc = "[G]oto [T]ype Def" })

    -- Enable advanced features for LSP servers that support them
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentColor) then
      vim.lsp.document_color.enable(true, { bufnr = args.buf })
    end
  end,
})
