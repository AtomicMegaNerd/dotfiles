{ config, ... }:
{
  home.file."${config.home.homeDirectory}/.agents/skills/herdr".source =
    "${config.programs.herdr.package}/share/skills/herdr/herdr";
  programs.herdr = {
    enable = true;
    mutableSettings = true;
    settings = {
      onboarding = false;
      theme.name = "catppuccin";
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
