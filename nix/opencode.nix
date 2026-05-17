{
  enable = true;
  settings = {
    autoupdate = false;
    shell = "fish";
    lsp = {
      nix = {
        command = [ "nil" ];
        extensions = [ ".nix" ];
      };
      go = {
        command = [ "gopls" ];
        extensions = [ ".go" ];
      };
      rust = {
        command = [ "rust-analyzer" ];
        extensions = [ ".rs" ];
      };
      lua = {
        command = [ "lua-language-server" ];
        extensions = [ ".lua" ];
      };
      python = {
        command = [ "ruff" ];
        extensions = [ ".py" ];
      };
      yaml = {
        command = [ "yaml-language-server" ];
        args = [ "--stdio" ];
        extensions = [
          ".yaml"
          ".yml"
        ];
      };
      bash = {
        command = [ "bash-language-server" ];
        args = [ "start" ];
        extensions = [
          ".sh"
          ".bash"
        ];
      };
      dockerfile = {
        command = [ "docker-language-server" ];
        args = [
          "start"
          "--stdio"
        ];
        extensions = [ "Dockerfile" ];
      };
    };
    formatter = {
      nix = {
        command = [ "nixfmt" ];
        extensions = [ ".nix" ];
      };
      go = {
        command = [ "gofmt" ];
        extensions = [ ".go" ];
      };
      prettier = {
        command = [
          "npx"
          "prettier"
          "--write"
        ];
        extensions = [
          ".js"
          ".ts"
          ".jsx"
          ".tsx"
          ".json"
          ".yaml"
          ".yml"
          ".md"
        ];
      };
      rust = {
        command = [ "rustfmt" ];
        extensions = [ ".rs" ];
      };
      lua = {
        command = [ "stylua" ];
        extensions = [ ".lua" ];
      };
      python = {
        command = [
          "ruff"
          "format"
        ];
        extensions = [ ".py" ];
      };
    };
    mcp = {
      github = {
        type = "local";
        command = [
          "github-mcp-server"
          "stdio"
        ];
        enabled = true;
      };
      context7 = {
        type = "local";
        command = [
          "npx"
          "-y"
          "@upstash/context7-mcp"
        ];
        enabled = true;
      };
    };
    permission = {
      bash = {
        "*" = "ask";
        "task *" = "allow";
        "live-server *" = "allow";
      };
      edit = "ask";
      external_directory = {
        "~/Code/**" = "allow";
        "~/.config/opencode/**" = "allow";
      };
    };
  };
  tui = {
    theme = "catppuccin-macchiato";
  };
}
