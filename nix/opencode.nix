{
  enable = true;
  settings = {
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
      oxfmt = {
        command = [ "oxfmt" ];
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
    permission = {
      bash = {
        "*" = "ask";
        "task *" = "allow";
        "live-server *" = "allow";
      };
      edit = "ask";
    };
  };
}
