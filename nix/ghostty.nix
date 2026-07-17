{ ... }:
{
  programs.ghostty = {
    enable = true;
    package = null;

    settings = {
      font-family = "Monaspace Argon";
      font-size = 16;
      theme = "catppuccin-frappe";
      cursor-style = "block";
      cursor-style-blink = true;
      macos-option-as-alt = true;
      shell-integration-features = "no-cursor,ssh-env,ssh-terminfo,sudo";
    };
  };
}
