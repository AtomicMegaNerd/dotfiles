# AtomicMegaNerd's Plan to Containerize Developer Tooling

## Goal

Set up OCI-compatible containers that run coding agents (claude, opencode, pi) so my Mac can be protected from the agents and from malicious packages from npm, PyPI, and similar registries. AtomicMegaNerd (amn) uses Nix. All of his projects have a `flake.nix` with a devShell.

We will start simple and then add additional capabilities as we go.

## High Level Requirements

My laptop is an M4 MacBook Air with 32GB of RAM running macOS 27 and the latest release of Apple's container tool. See [README.md](../../README.md).

- We will build the following images (one for each agentic harness):
  - `amn-opencode` <- pass in OpenCode Go subscription as environment variable
  - `amn-claude` <- pass in Claude Pro subscription as environment variable
  - `amn-pi` <- pass in OpenCode Go subscription as environment variable
  - We will bake the configuration into each image from the config files in this flake.
- Image building:
  - The images must be `linux-aarch64` as they will run on my Apple Silicon Mac.
  - We must be able to build each image on the Mac and push it to `git.megaparsec.ca` which is my local [forgejo](../services/forgejo.md) service which does have a container registry.
- Regardless of the agent permission setup all containers must use a non-root user
  - User `bot`, UID: `1000`, GID: `1000`.
- We will use the following directories:
  - `/home/bot` the home directory, agent configs live here
  - `/home/bot/project` this is where the project is mounted to.
  - `/work/` additional scratch space for agents to do testing and work
  - `/nix/` we will need to be able to write to the nix store to make the flake devShells work.
  - All other paths will be restricted (user `bot` will not have write access).
- We will start with 4GB of memory for each container.
- All secrets via `-e` only.
  - Each container will also need to pass in credentials for:
    - either `gh` (GitHub CLI) or GitHub MCP Server (or both; this is TBD).
  - Exposure of secrets to the entire container is accepted as being fully stateless and ephemeral has its own advantages for safety.
- We will not include ssh keys or ssh-agent as we do not want the agents to be able to push.
- Mount **only** the project directory `read/write`. No other files or directories will be mounted.
- On startup, container reads `flake.nix`, enters the devShell, then starts the agent.
  - Initially a completely ephemeral container that rebuilds the devShell each time is 100% ok.
  - If there is no devShell in the mounted folder we can abort with an error
  - We must be able to authenticate to the agent harness
- Fully stateless agents to start with.
- We will first try Apple's `container` tool. If Apple's tool does not work right now we can re-evaluate.

## Verified Facts

### Apple container

- For defaults, capabilities, `--ssh`, volumes, and run flags, see the [Apple container docs](https://github.com/apple/container/tree/main/docs).

### Claude Code

- `claude setup-token` prints a one-year OAuth token for a Pro plan. Set it as `CLAUDE_CODE_OAUTH_TOKEN`.
- See [settings.json](../../static/claude-code/settings.json) and [CLAUDE.md](../../static/claude-code/CLAUDE.md) for the configuration we will bake in.
- Paths will need to be fixed when we deploy to container.
- Leaving permissions as is - container is extra protection.

### pi

- Both OpenCode providers in pi (pay-as-you-go and Go) read the key from `OPENCODE_API_KEY` (OpenCode's "Pi" page).

### OpenCode (`anomalyco/opencode`)

- pass the API key from your OpenCode Go workspace as `OPENCODE_API_KEY` to OpenCode.

### Other tools

- `gh` reads `GH_TOKEN` (then `GITHUB_TOKEN`) (`gh help environment`).
- nixpkgs contains packages named `claude-code`, `opencode`, and `pi-coding-agent`.

## Recommended approach

### 1. Image layout

- `amn-claude`, `amn-opencode`, `amn-pi`: thin layers on `base`, installing each agent from nixpkgs.
- Entrypoint: `nix develop /home/bot/project --command <agent>`.

Example `base` Dockerfile (tested):

```Dockerfile
FROM docker.io/nixos/nix:latest

RUN cat /etc/passwd > /tmp/passwd.new && rm -f /etc/passwd && cp /tmp/passwd.new /etc/passwd \
 && cat /etc/group > /tmp/group.new && rm -f /etc/group && cp /tmp/group.new /etc/group \
 && echo 'bot:x:1000:1000:bot:/home/bot:/bin/sh' >> /etc/passwd \
 && echo 'bot:x:1000:' >> /etc/group \
 && mkdir -p /home/bot/project /work \
 && chown -R 1000:1000 /nix /home/bot /work

RUN rm -f /etc/nix/nix.conf \
 && printf 'sandbox = false\nbuild-users-group =\nexperimental-features = nix-command flakes\ntrusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=\n' > /etc/nix/nix.conf

ENV HOME=/home/bot
ENV USER=bot

USER 1000:1000
WORKDIR /home/bot/project
```

### 2. Run shape

- `container run --rm -it --memory 4g -w /home/bot/project`, credentials as `-e VAR` (no value).
- No `--ssh`, no other mounts.
- Egress open for now.

### 3. One container per project folder

- One agent container per project folder at a time. Sub-agents run inside it, managed by the app (claude, opencode, or pi).
- The container mounts the project directory read-write as a single mount. `.git` is part of it, so the agent can write to git, including `.git/hooks` and `.git/config`.
- The agent has only a read-only GitHub token and no ssh agent, so it has no credentials to push. The human does all pushes.
- Sub-agents share one working tree, so their edits are mixed in one `git diff`.

## Verification (spike first, before building three images)

1. Build `base` plus a trivial layer; confirm `nix develop` works inside the guest as non-root on a project flake that defines a devShell. Note anything that breaks.
2. Confirm bind mounts and `-e VAR` passthrough on this macOS version. Record file ownership on the host after a guest write.
3. Confirm the host is untouched after a run except the mounted checkout (`git status`, plus a check that nothing else under `$HOME` changed).
4. Start one container and run a task that uses sub-agents: confirm edits appear on the host.
5. Credential test per agent: start each agent, confirm it authenticates from env alone, with no auth file written in the guest.
6. Supply-chain smoke test: in the guest, run an install script that tries to read `~/.ssh`, `$HOME`, and other projects; confirm none are reachable.

## Skills

- [apple/container@container](https://github.com/apple/container)
- [github/awesome-copilot@multi-stage-dockerfile](https://github.com/github/awesome-copilot)

## Links

- [Apple container docs](https://github.com/apple/container/tree/main/docs)
- [Claude Code authentication](https://code.claude.com/docs/en/authentication)
- [Anthropic: Claude Code dev containers](https://code.claude.com/docs/en/devcontainer)
- [pi coding-agent docs (including containerization.md)](https://github.com/earendil-works/pi/tree/main/packages/coding-agent/docs)
- OpenCode V2: [model credentials](https://opencode.ai/v2/docs/models), [providers](https://opencode.ai/v2/docs/cli/providers), and [Go in Pi](https://opencode.ai/v2/console/harnesses/pi)
- [GitHub CLI environment variables](https://cli.github.com/manual/gh_help_environment)
- [PaulDuvall: Claude Code devcontainer guide](https://github.com/PaulDuvall/claude-code/blob/main/docs/devcontainer-guide.md)
- [sayem314: Run Codex, Claude Code and OpenCode in Docker without giving them your host](https://dev.to/sayem314/run-codex-claude-code-and-opencode-in-docker-without-giving-them-your-host-1i3e)
- [Signadot: Running coding agents in parallel](https://www.signadot.com/blog/running-coding-agents-in-parallel/)
