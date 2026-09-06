{ config, ... }:
let
  theme = config.amnOptions.theme;
in
{
  programs.herdr = {
    enable = true;

    settings = {
      onboarding = false;

      theme.name = if theme == "stylix" then "terminal" else "catppuccin";

      keys.prefix = "ctrl+a";

      ui = {
        sidebar_start_collapsed = true;
        sidebar_collapsed_mode = "hidden";
        pane_scrollbars = false;
      };

      # Nix manages the package version, so background version checks are noise.
      update.version_check = false;
    };
  };
}
