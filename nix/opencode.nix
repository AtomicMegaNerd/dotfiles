{
  enable = true;
  context = ''
    # Global OpenCode Guidelines

    - Assume that your knowledge is out of date and needs to be updated.

    ## CLI tooling

    Prefer using CLI tooling.

    - Use `gh` to query github and *not* webfetch

    Example to get source code:

    ```bash
    gh api repos/nix-community/home-manager/contents/modules/programs/neovim/default.nix \
      -H "Accept: application/vnd.github.raw+json"
    ```

    The following modern CLI tools are installed on my systems:

    - ripgrep
    - fzf
    - fd
    - bat
    - eza (ls is aliased to this)

    Please use the modern replacements when possible as they are more capable.
  '';
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
        "jq *" = "allow";
        "rg *" = "allow";
        "fd *" = "allow";
        "fzf *" = "allow";
        "head *" = "allow";
        "bat *" = "allow";
        "tail *" = "allow";
        "eza *" = "allow";
        "tree *" = "allow";
        "wc *" = "allow";
        "sort *" = "allow";
        "uniq *" = "allow";
        "diff *" = "allow";
        "which *" = "allow";
        "ls *" = "allow";
        "cat *" = "allow";
        "find *" = "allow";
        "grep *" = "allow";
        "dirname *" = "allow";
        "basename *" = "allow";
        "realpath *" = "allow";
        "readlink *" = "allow";
        "git status *" = "allow";
        "git log *" = "allow";
        "git diff *" = "allow";
        "git show *" = "allow";
        "git branch" = "allow";
        "git branch -l *" = "allow";
        "git branch --list *" = "allow";
        "git remote *" = "allow";
        "git stash list *" = "allow";
      };
      external_directory = {
        "~/Code/**" = "allow";
        "~/.config/**" = "allow";
        "~/.local/share/**" = "allow";
        "~/.cache/**" = "allow";
        "/tmp/**" = "allow";
        "/opt/homebrew/**" = "allow";
      };
      edit = {
        "~/Code/**" = "ask";
        "~/.config/**" = "deny";
        "~/.local/share/**" = "deny";
        "~/.cache/**" = "deny";
        "/tmp/**" = "allow";
        "/opt/homebrew/**" = "deny";
      };
    };
  };
}
