{ pkgs, ... }:
{
  enable = true;
  enableFishIntegration = true;
  package = pkgs.ghostty-bin;

  settings = {
    theme = "Catppuccin Latte";
    font-family = "Monaspace Neon";
    font-size = 14;
    macos-option-as-alt = true;
  };
}
