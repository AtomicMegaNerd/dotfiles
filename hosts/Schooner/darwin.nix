{ pkgs, ... }:

{
  # Basic system settings
  networking.hostName = "Schooner";
  system.stateVersion = 4; # Update this if you want a different darwin version
  system.primaryUser = "rcd";
  nix.enable = false;

  # Enable nix-darwin modules you want here
  programs.fish.enable = true;
  programs.zsh.enable = true; # Enable if you use zsh

  # Enable Homebrew and manage casks
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap"; # Remove uninstalled casks and formulae
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
    brews = [ ]; # Add formulae here if needed
    global = {
      autoUpdate = true;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  # You can also add system packages here if you want:
  # environment.systemPackages = with pkgs; [ ];
}
