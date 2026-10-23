{
  config,
  lib,
  pkgs,
  ...
}:
let
  agentSkills = [
    "olafkfreund/nix-skills/skills/home-manager"
    "olafkfreund/nix-skills/skills/nix-darwin"
    "olafkfreund/nix-skills/skills/nix-workflow"
    "olafkfreund/nix-skills/skills/nix-language"
    "AtomicMegaNerd/agent-skills/rcd-golang"
    "AtomicMegaNerd/agent-skills/rcd-go-task"
    "AtomicMegaNerd/agent-skills/rcd-golangci-lint"
  ];

  skillName = skill: lib.last (lib.splitString "/" skill);
in
{
  home.packages = [ pkgs.skills ];

  home.activation.installAgentSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${
      lib.makeBinPath [
        pkgs.git
        pkgs.skills
      ]
    }:$PATH"

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
