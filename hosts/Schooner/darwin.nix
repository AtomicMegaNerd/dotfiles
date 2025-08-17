{ pkgs, ... }:

{
  networking.hostName = "Schooner";
  system.stateVersion = 4;
  system.primaryUser = "rcd";
  nix.enable = false;

  programs.fish.enable = true;
  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = [
      "1password"
      "amethyst"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "obsidian"
      "raycast"
      "zed"
      "zoom"
    ];
    brews = [ ];
    global = {
      autoUpdate = true;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;
}
