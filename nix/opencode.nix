{ ... }:
{
  catppuccin.opencode.enable = false;

  programs.opencode = {
    enable = true;
    context = ../static/hosts/Schooner/opencode/AGENTS.md;
    settings = builtins.fromJSON (builtins.readFile ../static/common/opencode/opencode.json);
    cli = builtins.fromJSON (builtins.readFile ../static/common/opencode/cli.json);
    agents = {
      rcd-go = ./../static/agents/rcd-go.md;
      rcd-nix = ./../static/agents/rcd-nix.md;
      python-coder = ./../static/agents/python-coder.md;
      react-coder = ./../static/agents/react-coder.md;
    };
  };
}
