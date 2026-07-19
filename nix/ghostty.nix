{ ... }:
{
  programs.ghostty = {
    enable = true;
    package = null;

    settings = {
      font-family = "Monaspace Argon";
      font-size = 16;
      font-feature = "ss01,ss02,ss03,ss04,ss05,ss06,ss07,ss08,ss09,ss10,calt,liga";
      theme = "catppuccin-frappe";
      cursor-style = "block";
      cursor-style-blink = true;
      macos-option-as-alt = true;
      macos-titlebar-style = "hidden";
      window-padding-x = 20;
      window-padding-y = 20;
      shell-integration-features = "no-cursor,ssh-env,ssh-terminfo,sudo";
    };
  };
}
