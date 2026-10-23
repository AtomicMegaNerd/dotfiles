{ ... }:
{
  programs.claude-code = {
    enable = true;
    mutableSettings = true;
    context = ./../static/claude-code/CLAUDE.md;
    settings = builtins.fromJSON (builtins.readFile ./../static/claude-code/settings.json);
  };
}
