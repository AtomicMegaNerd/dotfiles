{ pkgs, ... }:
{
  networking.hostName = "Schooner";
  system.stateVersion = 4;
  system.primaryUser = "rcd";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    max-jobs = "auto";
    trusted-users = [ "@admin" ];
  };

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;
  ids.gids.nixbld = 350;

  programs.fish.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = [
      "1password" # gui password manager
      "1password-cli" # cli password manager
      "amethyst" # window tiling
      "raycast" # launcher
      "zoom" # video meetings
      "obsidian" # markdown notes
      "calibre" # managing ebooks
      "linearmouse" # better logitech mouse settings
      "finetune" # per-app volume control
      "claude-code" # claude code cli
    ];
    enableFishIntegration = true;
    global = {
      autoUpdate = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
