{ context7Key }:
{
  enable = true;
  settings = {
    lsp = {
      ruff = {
        command = "ruff-lsp";
      };
      nix = {
        command = "nil";
      };
      lua = {
        command = "lua-language-server";
      };
      go = {
        command = "gopls";
      };
      rust = {
        command = "rust-analyzer";
      };
      dockerfile = {
        command = "docker-langserver";
        args = [ "--stdio" ];
      };
      yaml = {
        command = "yaml-language-server";
        args = [ "--stdio" ];
        options = {
          yaml = {
            keyOrdering = false;
          };
        };
      };
      bash = {
        command = "bash-language-server";
        args = [ "start" ];
      };
    };
    mcp = {
      github = {
        command = "github-mcp-server";
        type = "stdio";
        args = [ "stdio" ];
      };

      context7 = {
        type = "http";
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = context7Key;
        };
      };
    };
  };
}
