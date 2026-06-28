{ pkgs, ... }:
{
  enable = true;
  package = pkgs.ghostty-bin;

  settings = {
    theme = "TokyoNight Storm";

    font-family = "Monaspace Argon";
    font-size = 18;

    cursor-style = "block";
    cursor-style-blink = true;

    macos-option-as-alt = true;

    shell-integration-features = "no-cursor,ssh-env,ssh-terminfo,sudo";
  };
}
