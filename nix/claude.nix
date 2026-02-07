{
  enable = true;
  settings = {
    model = "sonnet";
    editor = "vim";
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
        command = "docker-language-server";
        args = [
          "start"
          "--stdio"
        ];
      };
      yaml = {
        command = "yaml-language-server";
        args = [ "--stdio" ];
      };
      bash = {
        command = "bash-language-server";
        args = [ "start" ];
      };
    };
  };
  mcpServers = {
    github = {
      command = "github-mcp-server";
      type = "stdio";
      args = [ "stdio" ];
    };

    context7 = {
      type = "stdio";
      command = "npx";
      args = [
        "-y"
        "@upstash/context7-mcp"
      ];
    };
  };
}
