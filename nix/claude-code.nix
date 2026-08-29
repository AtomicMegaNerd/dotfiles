{
  config,
  ...
}:
{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
    context = builtins.readFile ../static/claude/AGENTS.md;

    # Mirrors the LSP's enabled in ~/Code/Configs/rcd-nvim (lua/lsp.lua).
    # Claude Code only lets one server claim a file extension, so tsc owns
    # js/ts and biome keeps css/json. Python (ty/ruff) and docker are skipped.
    # The binaries themselves come from hm_base.nix and per-project devshells.
    lspServers = {
      bash = {
        command = "bash-language-server";
        args = [ "start" ];
        extensionToLanguage = {
          ".sh" = "bash";
          ".bash" = "bash";
        };
      };
      biome = {
        command = "biome";
        args = [ "lsp-proxy" ];
        extensionToLanguage = {
          ".css" = "css";
          ".json" = "json";
        };
      };
      emmet = {
        command = "emmet-language-server";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".html" = "html";
        };
      };
      go = {
        command = "gopls";
        args = [ "serve" ];
        extensionToLanguage = {
          ".go" = "go";
        };
      };
      lua = {
        command = "lua-language-server";
        extensionToLanguage = {
          ".lua" = "lua";
        };
      };
      markdown = {
        command = "marksman";
        args = [ "server" ];
        extensionToLanguage = {
          ".md" = "markdown";
        };
      };
      nix = {
        command = "nil";
        extensionToLanguage = {
          ".nix" = "nix";
        };
      };
      nushell = {
        command = "nu";
        args = [ "--lsp" ];
        extensionToLanguage = {
          ".nu" = "nushell";
        };
      };
      rust = {
        command = "rust-analyzer";
        extensionToLanguage = {
          ".rs" = "rust";
        };
      };
      toml = {
        command = "tombi";
        args = [ "lsp" ];
        extensionToLanguage = {
          ".toml" = "toml";
        };
      };
      typescript = {
        command = "tsc";
        args = [
          "--lsp"
          "--stdio"
        ];
        extensionToLanguage = {
          ".ts" = "typescript";
          ".tsx" = "typescriptreact";
          ".js" = "javascript";
          ".jsx" = "javascriptreact";
        };
      };
      xml = {
        command = "lemminx";
        extensionToLanguage = {
          ".xml" = "xml";
          ".xsd" = "xml";
          ".xsl" = "xml";
        };
      };
      yaml = {
        command = "yaml-language-server";
        args = [ "--stdio" ];
        extensionToLanguage = {
          ".yml" = "yaml";
          ".yaml" = "yaml";
        };
      };
    };

    mcpServers = {
      context7 = {
        type = "http";
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "\${CONTEXT7_API_KEY}";
        };
      };
    };

    settings = {
      theme = "dark";
      includeCoAuthoredBy = false;
    };
  };
}
