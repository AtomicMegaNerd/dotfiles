{
  config,
  lib,
  ...
}:
let
  # Skill packages/paths to install globally with the skills CLI.
  # Each entry is passed to: skills add <entry> --global --yes
  agentSkills = [
    "olafkfreund/nix-skills/skills/home-manager"
    "olafkfreund/nix-skills/skills/nix-workflow"
    "olafkfreund/nix-skills/skills/nix-language"
    "AtomicMegaNerd/agent-skills/rcd-golang"
    "AtomicMegaNerd/agent-skills/rcd-go-task"
    "AtomicMegaNerd/agent-skills/rcd-golangci-lint"
  ];

  skillName = skill: lib.last (lib.splitString "/" skill);
in
{
  home.activation.installAgentSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! command -v skills >/dev/null 2>&1; then
      echo "warning: 'skills' CLI not found in PATH, skipping agent skill installation"
      exit 0
    fi

    ${lib.concatMapStrings (
      skill:
      let
        name = skillName skill;
        skillFile = "${config.home.homeDirectory}/.agents/skills/${name}/SKILL.md";
      in
      ''
        if [ ! -f ${lib.escapeShellArg skillFile} ]; then
          run echo "Installing skill: ${skill}"
          run skills add ${lib.escapeShellArg skill} --global --yes
        else
          run echo "Skill already installed: ${name}, skipping"
        fi
      ''
    ) agentSkills}

    run echo "Updating global skills"
    run skills update -g -y
  '';
}
