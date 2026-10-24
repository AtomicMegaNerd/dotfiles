{ pkgs, ... }:
{
  imports = [ ../../nix/nix-common.nix ];

  networking.hostName = "Schooner";
  system.stateVersion = 4;
  system.primaryUser = "rcd";

  nix = {
    settings.trusted-users = [ "@admin" ];

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

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      interval = {
        Hour = 2;
        Minute = 0;
      };
      extraArgs = "--keep-since 7d --keep 3";
    };
  };

  fonts.packages = with pkgs; [
    monaspace
  ];

  homebrew = {
    enable = true;
    taps = [
      {
        name = "acsandmann/tap";
        trusted = true;
      }
    ];
    brews = [
      {
        name = "rift";
        start_service = true;
        restart_service = "changed";
      }
      {
        name = "container";
      }
    ];
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
      "calibre" # managing ebooks
      "finetune" # per-app volume control
      "ghostty" # terminal app
      "linearmouse" # better logitech mouse settings
      "zoom" # video meetings
      "netnewswire" # RSS
      "obsidian" # Note taking
    ];
    enableFishIntegration = true;
    global = {
      autoUpdate = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
