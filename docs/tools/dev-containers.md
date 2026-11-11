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
    - We are not ready to implement `amn-pi` yet but will do so later.
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
  - `/tmp/` can also be used.
  - `/nix/` we will need to be able to write to the nix store to make the flake devShells work.
  - All other paths will be restricted (user `bot` will not have write access).
- We will start with 4GB of memory for each container.
- All secrets via `-e` only.
  - Each container will also need to pass in credentials for:
    - either `gh` (GitHub CLI) or GitHub MCP Server (or both; this is TBD).
  - Exposure of secrets to the entire container is accepted as being fully stateless and ephemeral has its own advantages for safety.
- We will not include ssh keys or ssh-agent as we do not want the agents to be able to push. It is okay for them to make commits.
- Mount **only** the project directory `read/write`. No other files or directories will be mounted.
- On startup, container reads `flake.nix`, enters the devShell, then starts the agent.
  - Initially a completely ephemeral container that rebuilds the devShell each time is 100% ok.
  - If there is no devShell in the mounted folder we can abort with an error
  - We must be able to authenticate to the agent harness
- Fully stateless agents to start with.
- We will first try Apple's `container` tool. If Apple's tool does not work right now we can re-evaluate.

## Implementation

### Image layout

One multi-stage `Dockerfile` per agent harness.

The following static files are copied into the image:

#### nix.conf

```ini
build-users-group =
experimental-features = nix-command flakes
```

#### Claude

```Dockerfile
FROM docker.io/nixos/nix:latest AS amn-agent-base

ARG USERNAME=bot
ARG USER_UID=1000
ARG USER_GID=1000
ARG HOME_DIR=/home/${USERNAME}
ARG PROJECT_DIR=${HOME_DIR}/project
ARG WORK_DIR=/work

ENV HOME=${HOME_DIR}
ENV USER=${USERNAME}
ENV PATH=${HOME_DIR}/.nix-profile/bin:${PATH}
ENV NIXPKGS_ALLOW_UNFREE=1

COPY --chown=${USER_UID}:${USER_GID} nix.conf ${HOME_DIR}/.config/nix/nix.conf

RUN echo "${USERNAME}:x:${USER_UID}:${USER_GID}:${USERNAME}:${HOME_DIR}:/bin/sh" >> /etc/passwd \
 && echo "${USERNAME}:x:${USER_GID}:" >> /etc/group \
 && mkdir -p ${PROJECT_DIR} ${WORK_DIR} \
 && chown -R ${USER_UID}:${USER_GID} /nix ${HOME_DIR} ${WORK_DIR}

USER ${USER_UID}:${USER_GID}
WORKDIR ${PROJECT_DIR}

FROM amn-agent-base AS amn-claude
RUN nix profile install --impure github:NixOS/nixpkgs/nixpkgs-unstable#claude-code
# Need to COPY claude config (settings.json and CLAUDE.md) into ${HOME_DIR}/.claude
ENTRYPOINT ["nix", "develop", "--command", "claude"]
```

#### OpenCode

Replace `amn-claude` with:

```Dockerfile
FROM amn-agent-base AS amn-opencode
RUN nix profile install github:NixOS/nixpkgs/nixpkgs-unstable#opencode
# Need to COPY opencode config (opencode.json, cli.json, AGENTS.md) into ${HOME_DIR}/.config/opencode
ENTRYPOINT ["nix", "develop", "--command", "opencode"]
```

#### Pi

Replace `amn-claude` with:

```Dockerfile
FROM amn-agent-base AS amn-pi
RUN nix profile install github:NixOS/nixpkgs/nixpkgs-unstable#pi-coding-agent
# Need to COPY pi config (none exists yet)
ENTRYPOINT ["nix", "develop", "--command", "pi"]
```

### Build and push

- Log in once: `container registry login git.megaparsec.ca`
- Build one image per target, named for the Forgejo registry:
  - `container build --target amn-claude -t git.megaparsec.ca/atomicmeganerd/amn-claude .`
  - `container build --target amn-opencode -t git.megaparsec.ca/atomicmeganerd/amn-opencode .`
- Push: `container image push git.megaparsec.ca/atomicmeganerd/IMAGE_NAME`

### Run shape

- Run: `container run --rm -it --memory 4g --env-file <env-file> -v <project>:/home/bot/project git.megaparsec.ca/atomicmeganerd/IMAGE_NAME`
- Secrets go in the env file, one `KEY=value` per line (`#` comments and blank lines are ignored). Keep it outside the project directory, since the project is the only mount.
  - `amn-claude`: `CLAUDE_CODE_OAUTH_TOKEN`
  - `amn-opencode`: `OPENCODE_API_KEY`
  - GitHub credentials: TBD (`gh` or the GitHub MCP server).
- No `--ssh`, no other mounts.
- Egress open for now.

## Verification

- Build each image and confirm `nix develop` works inside the guest as `bot` on a project flake that defines a devShell.
- Confirm `-e VAR` passthrough, and that `bot` can write to `/home/bot`, `/work`, `/tmp`, and `/nix` but nowhere else.
- Confirm the host is untouched after a run except the mounted project (`git status`, plus a check that nothing else under `$HOME` changed).
- Push each image to `git.megaparsec.ca` and pull it back.
- Start one container and run a task that uses sub-agents: confirm edits appear on the host.
- Credential test per agent: start each agent, confirm it authenticates from env alone, with no auth file written in the guest.
- Supply-chain smoke test: in the guest, run an install script that tries to read `~/.ssh`, `$HOME`, and other projects; confirm none are reachable.

## Notes

### Apple container

- For defaults, capabilities, `--ssh`, volumes, and run flags, see the [Apple container docs](https://github.com/apple/container/tree/main/docs).

### Claude Code

- `claude setup-token` prints a one-year OAuth token for a Pro plan. Set it as `CLAUDE_CODE_OAUTH_TOKEN`.
- See [settings.json](../../static/claude-code/settings.json) and [CLAUDE.md](../../static/claude-code/CLAUDE.md) for the configuration we will bake in.
  - **Note:** these will have to be updated to the new paths, etc.
  - Leaving permissions as is - container is extra protection.

### OpenCode

- Pass the API key from the OpenCode Go workspace to OpenCode as `OPENCODE_API_KEY`.
- See [opencode.json](../../static/opencode/opencode.json), [cli.json](../../static/opencode/cli.json), and [AGENTS.md](../../static/opencode/AGENTS.md) for the configuration to bake into the image.
  - **Note:** these will have to be updated to the new paths, etc.
  - Leaving permissions as is - container is extra protection.

### pi (Future Work)

- Both OpenCode providers in pi (pay-as-you-go and Go) read the key from `OPENCODE_API_KEY` (OpenCode's "Pi" page).
- This is future work. We don't have a pi config yet.

### Other tools

- `gh` reads `GH_TOKEN` (then `GITHUB_TOKEN`) (`gh help environment`).
- nixpkgs contains packages named `claude-code`, `opencode`, and `pi-coding-agent`.

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
