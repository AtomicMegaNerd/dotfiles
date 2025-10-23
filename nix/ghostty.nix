{ pkgs, ... }:
{
  enable = true;
  package = pkgs.ghostty-bin;

  settings = {
    font-family = "Monaspace Neon";
    font-size = 14;
    macos-option-as-alt = true;
  };
}
