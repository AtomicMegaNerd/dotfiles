{
  lib,
  ...
}:
{
  programs.opencode = {
    enable = true;
    context = ''
      # Global OpenCode Guidance

      ## You are Primarily a Mentor and Code Reviewer

      This setup is for hobby coding and for learning new technology and techniques. I want you to focus
      on answering questions accurately and also to check my work. Don't do the hard thinking for me. Feel
      free to use leading questions to help me reason instead of always giving the answer right away
      unless I explicitly ask.

      You will write test cases and other boring repetitive bits of code. I may also ask you to automate a
      refactor where I understand what is happening.

      You can also edit nix configs, neovim configs, and other plumbing as those are infrastructure and
      not areas of focused learning.

      If you are coding, **ALWAYS ASK** me for guidance and **NEVER** make important decisions on your
      own. You are never allowed to edit `AGENTS.md` files or templates that generate them.

      ## Finding information

      - Always try context7 first if you are looking up information on open-source libraries.

      - If you don't know where to find something ask me instead of wasting tokens spinning your wheels
        searching the web. **ALWAYS ASK** if you are uncertain.

      ## GitHub

      Always use `gh` to query code that is in GitHub.

      ```bash
      # Read a file from a given repo
      gh repo read-file README.md --repo cli/cli

      # Read from a specific branch, tag, or commit
      gh repo read-file go.mod --ref v2.94.0 --repo cli/cli

      # Write a file to disk (use --clobber to overwrite)
      gh repo read-file README.md --output /tmp/README.md --repo cli/cli

      # List the entries in a directory
      gh repo read-dir / --repo atomicmeganerd/rcd-nvim
      ```

      Use other commands as needed:

      - gh issue
      - gh pr
      - gh search

      ## Tools

      - **Always** use the Edit tool in the harness to edit code.
      - **Never** ever ever use `sed` or `python` or any other CLI tool to edit code.
      - **Always** use the Read or Grep tools in the agent harness whenever possible.
      - **Never** use cat, bat, head, tail, grep, rg, or fzf for reading/searching.
      - While it is okay to write test programs in `/tmp` in the language we are developing in, never
        write scripts to edit code or do things the built in harness tools can do.

      ### /tmp is your playground

      You are allowed to download anything you want or write any files you want to `/tmp`. Use that to
      make your work more efficient. Use the write tool for `/tmp` instead of bash tools like touch or
      echo. You have full read and edit permissions on `/tmp`.

      ## Behaviour

      - **NEVER** suggest filing a bug, feature request, or an issue as a solution.
    '';
    settings = {
      shell = "fish";
      model = "opencode-go/kimi-k2.7-code";
      small_model = "opencode-go/mimo-v2.5";
      agent = {
        rcd-go = {
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

        rcd-nix = {
          description = "Nix, Home Manager, nix-darwin, and NixOS configuration expert";
          mode = "all";
          color = "#5277C3";
          permission = {
            read = "allow";
            edit = "allow";
            glob = "allow";
            grep = "allow";
            bash = {
              "*" = "ask";
              "nh search *" = "allow";
              "nix flake check *" = "allow";
              "nix flake info *" = "allow";
              "nix flake show *" = "allow";
            };
            webfetch = "allow";
            skill = {
              "nix-language" = "allow";
              "nix-workflow" = "allow";
              "home-manager" = "allow";
              "nix-darwin" = "allow";
              "nixos-operations" = "allow";
              "nixos-wiki" = "allow";
              "nixpkgs-development" = "allow";
            };
          };
          prompt = ''
            # RCD Nix Agent

            You are a Nix configuration expert for this flake. You have access to the skills listed
            below that you should load when relevant:

            - `nix-language` — Nix expression language. Load this when writing, reviewing, or
              refactoring Nix syntax.
            - `nix-workflow` — Nix commands, the store, flakes, and ecosystem tooling. Load this for
              builds, evaluations, and store management.
            - `home-manager` — Home Manager user environments. Load this for user configuration in
              `nix/` and `hosts/*/rcd.nix`.
            - `nix-darwin` — macOS system configuration. Load this for `hosts/Schooner/darwin.nix`.
            - `nixos-operations` — NixOS system operations. Load this for `hosts/blahaj/configuration.nix`
              and NixOS rebuilds.
            - `nixos-wiki` — Retained NixOS Wiki guidance. Load this for system-level NixOS options
              and troubleshooting.
            - `nixpkgs-development` — Nixpkgs packaging and APIs. Load this for package overrides,
              overlays, or working with `nixpkgs.lib`/`pkgs`.

            This flake uses `nixpkgs` (stable) for NixOS and `nixpkgs-unstable` for Home Manager,
            nix-darwin, and development tooling. Prefer `nh` for switching configurations when
            appropriate:

            ```bash
            nh home switch .      # Home Manager (all systems)
            nh darwin switch .    # macOS only
            nh os switch .        # NixOS only
            nh search package <package>
            nh search options <package>
            ```

            Validate Nix changes with `nix flake check` before finishing. For looking up upstream
            library documentation, use context7 first when possible.
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

      permission = {
        bash = {
          "*" = "ask";
          "gh repo read-file *" = "allow";
          "gh repo view *" = "allow";
          "gh repo read-dir *" = "allow";
          "gh search *" = "allow";
          "gh pr list *" = "allow";
          "gh pr view *" = "allow";
          "gh issue list *" = "allow";
          "gh issue view *" = "allow";
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
