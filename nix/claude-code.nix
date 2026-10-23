{ ... }:
{
  programs.claude-code = {
    enable = true;
    mutableSettings = true;
    context = ./../static/claude-code/CLAUDE.md;
    settings = builtins.fromJSON (builtins.readFile ./../static/claude-code/settings.json);
    agents = {
      rcd-go = ./../static/agents/rcd-go.md;
      rcd-nix = ./../static/agents/rcd-nix.md;
    };
  };
}
