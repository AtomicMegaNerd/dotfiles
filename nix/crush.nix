{
  enable = true;
  settings = {
    lsp = {
      nix = {
        command = "nil";
      };
      go = {
        command = "gopls";
      };
      rust = {
        command = "rust-analyzer";
      };
      lua = {
        command = "lua-language-server";
      };
      python = {
        command = "ruff";
      };
      yaml = {
        command = "yaml-language-server";
        args = [ "--stdio" ];
      };
      bash = {
        command = "bash-language-server";
        args = [ "start" ];
      };
      dockerfile = {
        command = "docker-language-server";
        args = [
          "start"
          "--stdio"
        ];
      };
    };
    options = {
      context_paths = [ "/Users/rcd/Code" ];
      tui = {
        compact_mode = true;
      };
      debug = false;
    };
  };
}
