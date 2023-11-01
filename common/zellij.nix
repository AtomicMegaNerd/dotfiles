{ pkgs }:
{
  enable = true;
  enableFishIntegration = true;
  settings = {
    pane_frames = false;
    theme = "catppuccin-frappe";
    default_layout = "disable-status-bar";
  };
}
