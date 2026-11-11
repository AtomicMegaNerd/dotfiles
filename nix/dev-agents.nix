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
        [ "$#" -eq 0 ] && set -- claude opencode
        trap 'container builder stop' EXIT
        for name in "$@"; do
          container build --cpus 8 --memory 16g \
            -t ${registry}/amn-"$name" ${repo}/amn-"$name"
          container image push ${registry}/amn-"$name"
        done
      '';
    })

    (pkgs.writeShellApplication {
      name = "amn-agent";
      runtimeInputs = [ pkgs.age ];
      text = ''
        name=''${1:?usage: amn-agent <claude|opencode> [project-dir]}
        project=$(realpath "''${2:-.}")
        [ -f "$project/flake.nix" ] || { echo "no flake.nix in $project" >&2; exit 1; }
        exec container run --rm -it --memory 4g \
          --env-file <(age -d -i <(op read "op://Private/RCD 2022 SSH Key/private key") \
            ${secrets}/amn-"$name".env.age) \
          -v "$project":/home/bot/project \
          ${registry}/amn-"$name"
      '';
    })
  ];
}
