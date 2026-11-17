{ config, pkgs, ... }:
let
  repo = "${config.home.homeDirectory}/Code/Configs/dotfiles/containers/dev-agents";
  registry = "git.megaparsec.ca/atomicmeganerd";
  secrets = "${config.home.homeDirectory}/Code/Configs/dotfiles/secrets";
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "amn-agent-build";
      text = ''
        [ "$#" -eq 0 ] || { echo "usage: amn-agent-build" >&2; exit 1; }
        trap 'container builder stop' EXIT
        container build --cpus 8 --memory 16g \
          -t ${registry}/amn-opencode ${repo}/amn-opencode
        container image push ${registry}/amn-opencode
      '';
    })

    (pkgs.writeShellApplication {
      name = "amn-agent";
      runtimeInputs = [ pkgs.age ];
      text = ''
        [ "$#" -le 1 ] || { echo "usage: amn-agent [project-dir]" >&2; exit 1; }
        project=$(realpath "''${1:-.}")
        [ -f "$project/flake.nix" ] || { echo "no flake.nix in $project" >&2; exit 1; }
        exec container run --rm -it --memory 4g \
          --env-file <(age -d -i <(op read "op://Private/RCD 2022 SSH Key/private key") \
            ${secrets}/amn-opencode.env.age) \
          -v "$project":/home/bot/project \
          ${registry}/amn-opencode
      '';
    })
  ];
}
