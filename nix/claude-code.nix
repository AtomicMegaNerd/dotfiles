{
  config,
  pkgs,
  ...
}:
let
  mkAgentsMd = import ./lib/agents-md.nix { inherit pkgs; };
in
{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
    context = mkAgentsMd {
      template = ../static/agents-template.md;
      title = "Global Claude Code Guidance";
      context7Line = "- Always try context7 first if you are looking up information on open-source libraries.";
    };

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

    settings = {
      theme = "dark";
      includeCoAuthoredBy = false;
      autoMemoryEnabled = false;
      permissions = {
        defaultMode = "default";
      };
    };
  };
}
