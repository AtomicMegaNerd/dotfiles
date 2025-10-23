{ pkgs, ... }:

{
  networking.hostName = "Schooner";
  system.stateVersion = 4;
  system.primaryUser = "rcd";
  nix.enable = false;

  programs.fish.enable = true;

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
      "raycast"
      "zoom"
      "obsidian"
    ];
    brews = [ ];
    global = {
      autoUpdate = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman
    podman-compose
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
