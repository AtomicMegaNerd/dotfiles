{ ... }:
{
  programs.opencode = {
    enable = true;
    mutableSettings = true;
    context = ./../static/opencode/AGENTS.md;
    settings = builtins.fromJSON (builtins.readFile ./../static/opencode/opencode.json);
    cli = builtins.fromJSON (builtins.readFile ./../static/opencode/cli.json);
  };
}
