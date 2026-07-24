{
  config,
  lib,
  pkgs,
  ...
}:
{
  # This will clone my agent skills and then symlink each skill directory into
  # the skills/ folder of each agent that I have installed on the system. This
  # will only do the clone if the repo is not yet present. It will also
  # do the symlinks if they are not already present.
  home.activation.setupAgentSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    skills_repo="${config.home.homeDirectory}/Code/Skills/agent-skills"

    if [ ! -d "$skills_repo" ]; then
      $DRY_RUN_CMD mkdir -p "$(dirname "$skills_repo")"
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG \
        https://github.com/AtomicMegaNerd/agent-skills \
        "$skills_repo"
    fi

    for skills_dir in \
      "${config.xdg.configHome}/opencode/skills" \
      "${config.xdg.configHome}/pi/agent/skills"
    do
      if [ ! -e "$skills_dir" ]; then
        $DRY_RUN_CMD mkdir -p "$skills_dir"
      fi

      for skill_src in "$skills_repo"/*; do
        if [ -d "$skill_src" ]; then
          skill_name=$(basename "$skill_src")
          skill_dst="$skills_dir/$skill_name"
          if [ ! -e "$skill_dst" ]; then
            $DRY_RUN_CMD ln -sf "$skill_src" "$skill_dst"
          fi
        fi
      done
    done
  '';
}
