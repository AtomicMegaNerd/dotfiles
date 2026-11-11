FROM docker.io/nixos/nix:latest

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

COPY --chown=${USER_UID}:${USER_GID} settings.json CLAUDE.md ${HOME_DIR}/.claude/

ENTRYPOINT ["nix", "develop", ".#agent", "--command", "claude"]
