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
- All secrets via environment variables only, passed with `--env-file`.
  - Credentials needed for each agent harness, its subscriptions, and for a read-only tokten for `gh`.
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

#### Shared Base

The following static files are copied into all images:

##### nix.conf

```ini
build-users-group =
experimental-features = nix-command flakes
```

##### gitconfig

Agents may commit but not push, so commits need an identity.

```ini
[user]
  email = "chris@megaparsec.ca"
  name = "Chris Dunphy"

[safe]
  directory = /home/bot/project
```

##### flake.nix

Defines the shared tools for all images as one package. The lock file is generated during the image build.

```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      tools = with pkgs; [
        git
        gh
        fd
        ripgrep
        bat
        oxfmt
        oxlint
        markdownlint-cli2
        yamllint
      ];
    in
    {
      packages.aarch64-linux = {
        default = pkgs.buildEnv {
          name = "amn-base";
          paths = tools;
        };
        claude-code = pkgs.claude-code;
        opencode = pkgs.opencode;
        pi-coding-agent = pkgs.pi-coding-agent;
      };
    };
}
```

This is the shared code that is shared by all agent images below:

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

COPY --chown=${USER_UID}:${USER_GID} nix.conf ${HOME_DIR}/.config/nix/nix.conf
COPY --chown=${USER_UID}:${USER_GID} gitconfig ${HOME_DIR}/.gitconfig
COPY --chown=${USER_UID}:${USER_GID} flake.nix ${HOME_DIR}/.config/amn-image/flake.nix

RUN echo "${USERNAME}:x:${USER_UID}:${USER_GID}:${USERNAME}:${HOME_DIR}:/bin/sh" >> /etc/passwd \
 && echo "${USERNAME}:x:${USER_GID}:" >> /etc/group \
 && mkdir -p ${PROJECT_DIR} ${WORK_DIR} \
 && chown -R ${USER_UID}:${USER_GID} /nix ${HOME_DIR} ${WORK_DIR}

USER ${USER_UID}:${USER_GID}
WORKDIR ${PROJECT_DIR}

RUN nix profile add path:${HOME_DIR}/.config/amn-image
```

#### Claude

```Dockerfile
# Add based Dockerfile code above

FROM amn-agent-base AS amn-claude
RUN nix profile add path:/home/bot/.config/amn-image#claude-code
# Need to COPY claude config (settings.json and CLAUDE.md) into ${HOME_DIR}/.claude
ENTRYPOINT ["nix", "develop", ".#agent", "--command", "claude"]
```

#### OpenCode

```Dockerfile
# Add based Dockerfile code above

FROM amn-agent-base AS amn-opencode
RUN nix profile add path:/home/bot/.config/amn-image#opencode
# Need to COPY opencode config (opencode.json, cli.json, AGENTS.md) into ${HOME_DIR}/.config/opencode
ENTRYPOINT ["nix", "develop", ".#agent", "--command", "opencode"]
```

#### Pi

```Dockerfile
# Add based Dockerfile code above

FROM amn-agent-base AS amn-pi
RUN nix profile add path:/home/bot/.config/amn-image#pi-coding-agent
# Need to COPY pi config (none exists yet)
ENTRYPOINT ["nix", "develop", ".#agent", "--command", "pi"]
```

### Build

- Run the following for each Dockerile (paths TBD):
  - `container build -f <FILE> -t git.megaparsec.ca/atomicmeganerd/<IMAGE_NAME> .`

### Run shape

- Run: `container run --rm -it --memory 4g --env-file <env-file> -v <project>:/home/bot/project git.megaparsec.ca/atomicmeganerd/IMAGE_NAME`

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
