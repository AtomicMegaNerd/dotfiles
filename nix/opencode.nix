{ ... }:
{
  catppuccin.opencode.enable = false;

  programs.opencode = {
    enable = true;
    mutableSettings = true;
    context = ./../static/opencode/AGENTS.md;
    settings = builtins.fromJSON (builtins.readFile ./../static/opencode/opencode.json);
    cli = builtins.fromJSON (builtins.readFile ./../static/opencode/cli.json);
    agents = {
      rcd-go = ./../static/agents/rcd-go.md;
      rcd-nix = ./../static/agents/rcd-nix.md;
    };
  };
}
