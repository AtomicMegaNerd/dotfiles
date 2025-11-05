{ pkgs, ... }:
{
  enable = true;
  package = pkgs.ghostty-bin;

  settings = {
    font-family = "Monaspace Argon";
    font-size = 16;
    font-thicken = true;
    font-feature = "ss01,ss02,ss03,ss04,ss05,ss06,ss07,ss08,ss09,ss10,calt,liga";
    macos-option-as-alt = true;
  };
}
