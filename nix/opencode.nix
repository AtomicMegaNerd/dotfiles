{ ... }:
let
  agentSystem = name: builtins.readFile ./../static/agents/${name}.md;

  opencodeSettings =
    let
      base = builtins.fromJSON (builtins.readFile ./../static/opencode/opencode.json);
    in
    base
    // {
      agents = base.agents // {
        rcd-go = base.agents.rcd-go // {
          system = agentSystem "rcd-go";
        };
        rcd-nix = base.agents.rcd-nix // {
          system = agentSystem "rcd-nix";
        };
      };
    };
in
{
  catppuccin.opencode.enable = false;

  programs.opencode = {
    enable = true;
    mutableSettings = true;
    context = ./../static/opencode/AGENTS.md;
    settings = opencodeSettings;
    cli = builtins.fromJSON (builtins.readFile ./../static/opencode/cli.json);
  };
}
