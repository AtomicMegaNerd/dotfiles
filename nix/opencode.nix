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
      model = "opencode-go/kimi-k2.7-code";
      small_model = "opencode-go/mimo-v2.5";
      agent = {
        go = {
          description = "Go programming, build, lint, and test expert";
          mode = "all";
          color = "#00ADD8";
          permission = {
            read = "allow";
            edit = "allow";
            glob = "allow";
            grep = "allow";
            bash = {
              "*" = "ask";
              "task *" = "allow";
              "golangci-lint *" = "allow";
              "go *" = "allow";
            };
            webfetch = "allow";
            skill = {
              "go" = "allow";
              "task" = "allow";
              "golangci-lint" = "allow";
              "go-task" = "allow";
            };
            task = {
              "go" = "allow";
            };
          };
          prompt = ''
            # RCD Go Agent

            You are a Go programming expert. You have access to the skills listed below that you should load
            when relevant:

            - `rcd-golang` — Idiomatic Go patterns and best practices). Load this when writing, reviewing, or
              refactoring Go code.
            - `rcd-go-task` — The Task build tool. Load this when running builds, tests, or lints.
            - `rcd-golangci-lint` — The linter. Load this when running or configuring the linter.

            **Always load the `go` skill immediately.** Load `task`, `go-task`, and `golangci-lint` as needed.

            For Azure functions pipeline work, deployment, troubleshooting, etc. please delegate to the
            **azfunc-go** agent.

            ## pkg.go.dev CLI Tool

            **`pkgsite-cli`** is the best way to lookup reference information for Go code that is published to
            `pkgs.go.dev`. This tool will be installed in Go projects already.

            ```bash
            pkgsite-cli search "uuid"
            pkgsite-cli package github.com/google/go-cmp/cmp
            pkgsite-cli package --imported-by github.com/google/go-cmp/cmp
            pkgsite-cli package --symbols github.com/google/go-cmp/cmp
            pkgsite-cli module -versions github.com/google/go-cmp
            pkgsite-cli module -packages github.com/google/go-cmp
            ```
          '';
        };
      };
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
          "fd *" = "allow";
          "eza *" = "allow";
          "tree *" = "allow";
          "wc *" = "allow";
          "sort *" = "allow";
          "uniq *" = "allow";
          "diff *" = "allow";
          "which *" = "allow";
          "ls *" = "allow";
          "find *" = "allow";
          "pwd *" = "allow";
          "dirname *" = "allow";
          "basename *" = "allow";
          "realpath *" = "allow";
          "readlink *" = "allow";
          "git status *" = "allow";
          "git log *" = "allow";
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
