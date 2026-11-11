# AtomicMegaNerd's Plan to Containerize Developer Tooling

## Goal

Use OCI-compatible containers that run coding agents (claude, opencode) so my Mac can be protected from the agents and from malicious packages from npm, PyPI, and similar registries. AtomicMegaNerd (amn) uses Nix. All of his projects have a `flake.nix` with a devShell.

Our initial implementation is very simple. We can add from there.

## High Level Requirements

- One image for each agentic harness we use.
- We bake the configuration into each image from the config files in this flake.
- Pass secrets with env-file only. Creds needed for each agent harness, its subscriptions, and for a read-only tokten for `gh`.
- We create a user called `bot` which uses the following directories:
  - `/home/bot` the home directory, agent configs live here
  - `/home/bot/project` this is where the project is mounted to.
  - `/work/` additional scratch space for agents to do testing and work
  - `/tmp/` can also be used.
  - `/nix/` user `bot` can write to the nix store, which the flake devShells need.
  - All other paths will be restricted (user `bot` will not have write access).
- No ssh keys we do not want agents to push.
- Mount **only** the project directory `read/write`. No other files or directories are mounted.
- On startup, container reads `flake.nix`, enters the devShell, then starts the agent.

## Images

See the directories below for our images:

- [amn-claude](../../containers/dev-agents/amn-claude/)
- [amn-opencode](../../containers/dev-agents/amn-opencode/)

### Build

See [dev-agents.nix](../../nix/dev-agents.nix) for our build and run scripts.

- Specify which agent (`claude` or `opencode`)
- Pushes to [forgejo](../services/forgejo.md] container registry at `git.megaparsec.ca`

```fish
amn-agent-build claude
```

### Run

- Specify which agent (`claude` or `opencode`) and the project path

```fish
amn-agent opencode .
```

## Secrets

The env files are agenix secrets, `amn-claude.env.age` and `amn-opencode.env.age`. See [secrets.md](../infra/secrets.md) for how to add and edit them. `amn-agent` decrypts them at launch.

Each file holds `KEY=value` lines:

```text
# amn-claude.env
CLAUDE_CODE_OAUTH_TOKEN=...
GH_TOKEN=...

# amn-opencode.env
OPENCODE_API_KEY=...
GH_TOKEN=...
CONTEXT7_API_KEY=...
```

## Verification

- Verify that each agent harness is authenticated even though we only passed in environent variables
- Verify that each image is authenticated to `gh`.

## Notes

### Nix

- We use `forAllSystems` in our project flakes so all image CPU arches are supported.
- The container runs `nix develop .#agent`, so each project needs an `agent` devShell.
  - Only put the tools the agent needs in the agent output, this makes the images build much faster.

```nix
devShells = forAllSystems (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    shared = [ pkgs.go_1_27 pkgs.gotools pkgs.golangci-lint pkgs.go-task ];
    hostOnly = [ pkgs.gopls pkgs.goreleaser pkgs.oxfmt ];
  in
  {
    default = pkgs.mkShell { buildInputs = shared ++ hostOnly; };
    agent = pkgs.mkShell { buildInputs = shared; };
  }
);
```

### Claude Code

- `claude setup-token` prints a one-year OAuth token for a Pro plan. Set it as `CLAUDE_CODE_OAUTH_TOKEN`.
- Permissions are left as is - the container is extra protection.

### OpenCode

- Pass the API key from the OpenCode Go workspace to OpenCode as `OPENCODE_API_KEY`.
- Permissions are left as is - the container is extra protection.

### Other tools

- `gh` reads `GH_TOKEN` (then `GITHUB_TOKEN`) (`gh help environment`).

## Links

- [Apple container docs](https://github.com/apple/container/tree/main/docs)
- [Claude Code authentication](https://code.claude.com/docs/en/authentication)
- [Anthropic: Claude Code dev containers](https://code.claude.com/docs/en/devcontainer)
- OpenCode V2: [model credentials](https://opencode.ai/v2/docs/models) and [providers](https://opencode.ai/v2/docs/cli/providers)
- [GitHub CLI environment variables](https://cli.github.com/manual/gh_help_environment)
- [PaulDuvall: Claude Code devcontainer guide](https://github.com/PaulDuvall/claude-code/blob/main/docs/devcontainer-guide.md)
- [sayem314: Run Codex, Claude Code and OpenCode in Docker without giving them your host](https://dev.to/sayem314/run-codex-claude-code-and-opencode-in-docker-without-giving-them-your-host-1i3e)
- [Signadot: Running coding agents in parallel](https://www.signadot.com/blog/running-coding-agents-in-parallel/)
