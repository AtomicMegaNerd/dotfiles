{ lib }:
{
  enable = true;
  context = builtins.readFile ../static/AGENTS.md;
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
        "gh api repos/*" = "allow";
        "gh api search/*" = "allow";
        "gh api users/*" = "allow";
        "gh api orgs/*" = "allow";
        "gh api gists/*" = "allow";
        "gh pr list *" = "allow";
        "gh pr view *" = "allow";
        "gh issue list *" = "allow";
        "gh issue view *" = "allow";
        "gh run list *" = "allow";
        "gh run view *" = "allow";
        "nh search *" = "allow";
        "nix flake check *" = "allow";
        "nix flake info *" = "allow";
        "nix flake show *" = "allow";
        "nixfmt *" = "allow";
        "yamllint *" = "allow";
        "biome *" = "allow";
        "markdownlint-cli2 *" = "allow";
        "oxfmt *" = "allow";
      };
      # By default nix will change the order of these keys, but the last rule wins here. So we must
      # use lib.hm.dag.entryAfter in some cases to ensure that they rule we want comes after another
      # rule that is being overridden.
      external_directory = {
        "~/Code/**" = "allow";
        "~/.config/bat/**" = "allow";
        "~/.config/btop/**" = "allow";
        "~/.config/containers/**" = "allow";
        "~/.config/direnv/**" = "allow";
        "~/.config/eza/**" = "allow";
        # For fish we want opencode to have access to all files except the credentials files. We
        # Have to tell nix to ensure the right ordering as noted above.
        "~/.config/fish/**" = "allow";
        "~/.config/fish/conf.d/credentials.fish" = lib.hm.dag.entryAfter [ "~/.config/fish/**" ] "deny";
        "~/.config/gh/**" = "allow";
        "~/.config/ghostty/**" = "allow";
        "~/.config/git/**" = "allow";
        "~/.config/github-copilot/*.json" = "allow";
        "~/.config/home-manager/**" = "allow";
        "~/.config/htop/**" = "allow";
        "~/.config/lazydocker/**" = "allow";
        "~/.config/lazygit/**" = "allow";
        "~/.config/linearmouse/**" = "allow";
        "~/.config/nushell/**" = "allow";
        "~/.config/nvim/**" = "allow";
        "~/.config/op/**" = "allow";
        "~/.config/opencode/**" = "allow";
        "~/.config/starship.toml" = "allow";
        "~/.config/television/**" = "allow";
        "~/.config/zed/**" = "allow";
        "~/.config/zellij/**" = "allow";
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
