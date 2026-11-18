# AtomicMegaNerd's Plan to Containerize Developer Tooling

## Goal

Use OCI-compatible containers to run OpenCode so my Mac can be protected from the agent and from malicious packages from npm, PyPI, and similar registries. AtomicMegaNerd (amn) uses Nix. All of his projects have a `flake.nix` with a devShell.

Our initial implementation is very simple. We can add from there.

## High Level Requirements

- One image for the agentic harness we use.
- We bake the configuration into each image from the config files in this flake.
- Pass secrets with env-file only. Credentials are needed for the agent and for a read-only token for `gh`.
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

- [amn-opencode](../../containers/dev-agents/amn-opencode/)

### Build

See [dev-agents.nix](../../nix/dev-agents.nix) for our build and run scripts.

- Build and push the OpenCode image
- Pushes to the [Forgejo](../services/forgejo.md) container registry at `git.megaparsec.ca`.

```fish
amn-agent-build
```

### Run

- Specify the project path

```fish
amn-agent .
```

## Secrets

The env file is the agenix secret `amn-opencode.env.age`. See [secrets.md](../infra/secrets.md) for how to add and edit it. `amn-agent` decrypts it at launch.

The file holds `KEY=value` lines:

```text
# amn-opencode.env
OPENCODE_API_KEY=...
GH_TOKEN=...
```

## Verification

- Verify that the agent is authenticated even though we only passed in environment variables.
- Verify that the image is authenticated to `gh`.

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

### OpenCode

- Pass the API key from the OpenCode Go workspace to OpenCode as `OPENCODE_API_KEY`.
- Permissions are left as is - the container is extra protection.

### Other tools

- `gh` reads `GH_TOKEN` (then `GITHUB_TOKEN`) (`gh help environment`).

## Links

- [Apple container docs](https://github.com/apple/container/tree/main/docs)
- OpenCode V2: [model credentials](https://opencode.ai/v2/docs/models) and [providers](https://opencode.ai/v2/docs/cli/providers)
- [GitHub CLI environment variables](https://cli.github.com/manual/gh_help_environment)
- [Signadot: Running coding agents in parallel](https://www.signadot.com/blog/running-coding-agents-in-parallel/)
