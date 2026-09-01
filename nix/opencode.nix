{
  lib,
  pkgs,
  ...
}:
let
  mkAgentsMd = import ./lib/agents-md.nix { inherit pkgs; };
in
{
  programs.opencode = {
    enable = true;
    context = mkAgentsMd {
      template = ../static/agents-template.md;
      title = "Global OpenCode Guidance";
      context7Line = "- Always try context7 first if you are looking up information on open-source libraries.";
    };
    settings = {

      shell = "fish";
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
          };
          enabled = true;
        };
      };

      # Sadly this does not appear to work right now? I am leaving it in as this will be really
      # nice to have once it is fixed:
      #
      # See https://github.com/anomalyco/opencode/issues/34040
      references = {
        code = {
          path = "~/Code/";
          description = "My personal code projects directory";
          hidden = false;
        };

        opencode-cfg = {
          path = "~/.config/opencode/";
          description = "My opencode config";
          hidden = false;
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
          "pwd *" = "allow";
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
          "git remote" = "allow";
          "git remote -v" = "allow";
          "git remote show *" = "allow";
          "git stash list *" = "allow";
          "gh repo read-file *" = "allow";
          "gh repo view *" = "allow";
          "gh repo read-dir *" = "allow";
          "gh search *" = "allow";
          "gh pr list *" = "allow";
          "gh pr view *" = "allow";
          "gh issue list *" = "allow";
          "gh issue view *" = "allow";
          "nh search *" = "allow";
          "nix flake check *" = "allow";
          "nix flake info *" = "allow";
          "nix flake show *" = "allow";
          "yamllint *" = "allow";
          "markdownlint-cli2 *" = "allow";
          "date *" = "allow";
        };

        read = {
          "*" = "allow";
          "*.env" = lib.hm.dag.entryAfter [ "*" ] "deny";
          "*.envrc" = lib.hm.dag.entryAfter [ "*" ] "deny";
          "*.env.*" = lib.hm.dag.entryAfter [ "*" ] "deny";
        };

        # `external_directory` matches the ABSOLUTE file path, so `~/` expansion works here.
        external_directory = lib.hm.dag.entryAfter [ "read" ] {
          "~/Code/**" = "allow";
          "~/.config/opencode/**" = "allow";
          "/tmp/**" = "allow";
        };

        # `edit` patterns match the file path RELATIVE to the worktree
        # (see packages/opencode/src/tool/edit.ts: path.relative(worktree, filePath)).
        # Absolute / `~/` rules never match here; use relative globs instead.
        # In-worktree files have no `..`; external dirs (/tmp, ~/.config) do.
        edit = lib.hm.dag.entryAfter [ "external_directory" ] {
          "*" = "ask";
          "*/tmp/*" = lib.hm.dag.entryAfter [ "*" ] "allow";
        };
      };
    };
  };
}
