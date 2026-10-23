{
  config,
  ...
}:
{
  programs.opencode = {
    enable = true;
    mutableSettings = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";

      permissions = [
        # Ask before accessing any path outside the project/worktree, then opt-in /tmp.
        {
          action = "external_directory";
          resource = "*";
          effect = "ask";
        }
        {
          action = "external_directory";
          resource = "/tmp/**";
          effect = "allow";
        }

        # Shell: ask by default, allow safe routine commands.
        {
          action = "shell";
          resource = "*";
          effect = "ask";
        }
        {
          action = "shell";
          resource = "gh repo read-file *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "gh repo view *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "gh repo read-dir *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "gh search *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "gh pr list *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "gh pr view *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "gh issue list *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "gh issue view *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "yamllint *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "markdownlint-cli2 *";
          effect = "allow";
        }
        {
          action = "shell";
          resource = "date *";
          effect = "allow";
        }

        # Read: allow by default, deny env files.
        {
          action = "read";
          resource = "*";
          effect = "allow";
        }
        {
          action = "read";
          resource = "*.env";
          effect = "deny";
        }
        {
          action = "read";
          resource = "*.envrc";
          effect = "deny";
        }
        {
          action = "read";
          resource = "*.env.*";
          effect = "deny";
        }

        # Edit: ask by default, allow tmp files (in-worktree and external).
        {
          action = "edit";
          resource = "*";
          effect = "ask";
        }
        {
          action = "edit";
          resource = "*/tmp/*";
          effect = "allow";
        }
        {
          action = "edit";
          resource = "/tmp/**";
          effect = "allow";
        }

        # Other discovery tools.
        {
          action = "glob";
          resource = "*";
          effect = "allow";
        }
        {
          action = "grep";
          resource = "*";
          effect = "allow";
        }
        {
          action = "webfetch";
          resource = "*";
          effect = "allow";
        }
      ];

      agents = {
        rcd-go = {
          description = "Go programming, build, lint, and test expert";
          mode = "all";
          color = "#00ADD8";
          system = ''
            # RCD Go Agent

            You are a Go programming expert. You have access to the skills listed below that
            you should load when relevant:

            - `rcd-golang` — Idiomatic Go patterns and best practices). Load this when
              writing, reviewing, or refactoring Go code.
            - `rcd-go-task` — The Task build tool. Load this when running builds, tests, or lints.
            - `rcd-golangci-lint` — The linter. Load this when running or configuring the linter.

            **Always load the `go` skill immediately.** Load `task`, `go-task`, and
            `golangci-lint` as needed.

            For Azure functions pipeline work, deployment, troubleshooting, etc. please
            delegate to the **azfunc-go** agent.

            ## pkg.go.dev CLI Tool

            **`pkgsite-cli`** is the best way to lookup reference information for Go code that
            is published to `pkgs.go.dev`. This tool will be installed in Go projects already.

            ```bash
            pkgsite-cli search "uuid"
            pkgsite-cli package github.com/google/go-cmp/cmp
            pkgsite-cli package --imported-by github.com/google/go-cmp/cmp
            pkgsite-cli package --symbols github.com/google/go-cmp/cmp
            pkgsite-cli module -versions github.com/google/go-cmp
            pkgsite-cli module -packages github.com/google/go-cmp
            ```
          '';
          permissions = [
            {
              action = "read";
              resource = "*";
              effect = "allow";
            }
            {
              action = "edit";
              resource = "*";
              effect = "ask";
            }
            {
              action = "glob";
              resource = "*";
              effect = "allow";
            }
            {
              action = "grep";
              resource = "*";
              effect = "allow";
            }
            {
              action = "shell";
              resource = "*";
              effect = "ask";
            }
            {
              action = "shell";
              resource = "task *";
              effect = "allow";
            }
            {
              action = "shell";
              resource = "golangci-lint *";
              effect = "allow";
            }
            {
              action = "shell";
              resource = "go *";
              effect = "allow";
            }
            {
              action = "webfetch";
              resource = "*";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "go";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "task";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "golangci-lint";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "go-task";
              effect = "allow";
            }
            {
              action = "subagent";
              resource = "go";
              effect = "allow";
            }
          ];
        };

        rcd-nix = {
          description = "Nix, Home Manager, nix-darwin, and NixOS configuration expert";
          mode = "all";
          color = "#5277C3";
          system = ''
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
            - `nixos-operations` — NixOS system operations. Load this for
              `hosts/blahaj/configuration.nix` and NixOS rebuilds.
            - `nixos-wiki` — Retained NixOS Wiki guidance. Load this for system-level NixOS options
              and troubleshooting.
            - `nixpkgs-development` — Nixpkgs packaging and APIs. Load this for package overrides,
              overlays, or working with `nixpkgs.lib`/`pkgs`.

            This flake uses `nixpkgs` (stable) for NixOS and `nixpkgs-unstable` for Home Manager,
            nix-darwin, and development tooling. Prefer `nh` for switching configurations when
            appropriate:
          '';
          permissions = [
            {
              action = "read";
              resource = "*";
              effect = "allow";
            }
            {
              action = "edit";
              resource = "*";
              effect = "ask";
            }
            {
              action = "glob";
              resource = "*";
              effect = "allow";
            }
            {
              action = "grep";
              resource = "*";
              effect = "allow";
            }
            {
              action = "shell";
              resource = "*";
              effect = "ask";
            }
            {
              action = "shell";
              resource = "nh search *";
              effect = "allow";
            }
            {
              action = "shell";
              resource = "nix flake check *";
              effect = "allow";
            }
            {
              action = "shell";
              resource = "nix flake info *";
              effect = "allow";
            }
            {
              action = "shell";
              resource = "nix flake show *";
              effect = "allow";
            }
            {
              action = "webfetch";
              resource = "*";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "nix-language";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "nix-workflow";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "home-manager";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "nix-darwin";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "nixos-operations";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "nixos-wiki";
              effect = "allow";
            }
            {
              action = "skill";
              resource = "nixpkgs-development";
              effect = "allow";
            }
          ];
        };
      };

      mcp = {
        servers = {
          context7 = {
            type = "remote";
            url = "https://mcp.context7.com/mcp";
            headers = {
              CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
            };
            disabled = false;
          };
        };
      };
    };
  };

  home.file."${config.xdg.configHome}/opencode/AGENTS.md".text = ''
    # Global OpenCode Guidance

    ## You are Primarily a Mentor and Code Reviewer

    This setup is for hobby coding and for learning new technology and techniques. I want you
    to focus on answering questions accurately and also to check my work. Don't do the hard
    thinking for me. Feel free to use leading questions to help me reason instead of always
    giving the answer right away unless I explicitly ask.

    You will write test cases and other boring repetitive bits of code. I may also ask you to
    automate a refactor where I understand what is happening.

    You can also edit nix configs, neovim configs, and other plumbing as those are
    infrastructure and not areas of focused learning.

    If you are coding, **ALWAYS ASK** me for guidance and **NEVER** make important decisions
    on your own. You are never allowed to edit `AGENTS.md` files or templates that generate
    them.

    ## Finding information

    - Always try context7 first if you are looking up information on open-source libraries.

    - If you don't know where to find something ask me instead of wasting tokens spinning
      your wheels searching the web. **ALWAYS ASK** if you are uncertain.

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
    - While it is okay to write test programs in `/tmp` in the language we are developing
      in, never write scripts to edit code or do things the built in harness tools can do.

    ### /tmp is your playground

    You are allowed to download anything you want or write any files you want to `/tmp`. Use
    that to make your work more efficient. Use the write tool for `/tmp` instead of bash
    tools like touch or echo. You have full read and edit permissions on `/tmp`.

    ## Behaviour

    - **NEVER** suggest filing a bug, feature request, or an issue as a solution.
  '';
}
