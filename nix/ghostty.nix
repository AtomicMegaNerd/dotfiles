{ pkgs, ... }:
{
  enable = true;
  package = pkgs.ghostty-bin;

  settings = {
    theme = "TokyoNight Storm";

    font-family = "Monaspace Argon";
    font-size = 18;
    font-feature = "ss01,ss02,ss03,ss04,ss05,ss06,ss07,ss08,ss09,ss10,calt,liga";

    cursor-style = "block";
    cursor-style-blink = true;

    fullscreen = true;
    macos-option-as-alt = true;

    shell-integration-features = "no-cursor,ssh-env,ssh-terminfo,sudo";
  };
}
