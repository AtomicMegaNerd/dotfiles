{ pkgs, ... }:
{
  networking.hostName = "Schooner";
  system.stateVersion = 4;
  system.primaryUser = "rcd";

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@admin" ];
    };

    gc = {
      automatic = true;
      interval = {
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 10d";
    };

    optimise = {
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 30;
      };
    };
  };

  ids.gids.nixbld = 350;

  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    monaspace
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      extraFlags = [
        "--force-cleanup"
      ];
    };
    casks = [
      "1password" # gui password manager
      "1password-cli" # cli password manager
      "zoom" # video meetings
      "calibre" # managing ebooks
      "linearmouse" # better logitech mouse settings
      "finetune" # per-app volume control
      "ghostty" # terminal app
      "amethyst" # tiling WM
      "zed" # editor
    ];
    enableFishIntegration = true;
    global = {
      autoUpdate = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
