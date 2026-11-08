{ pkgs, ... }:
{
  imports = [ ../../nix/nix-common.nix ];

  networking.hostName = "Schooner";
  system.stateVersion = 7;
  system.primaryUser = "rcd";
  users.users.rcd.openssh.authorizedKeys.keys = [
    (builtins.readFile ../../static/rcd_pub_key)
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pki.certificateFiles = [
    ../../static/rcd-rootCA-pub.pem
  ];

  nix = {
    settings.trusted-users = [ "@admin" ];
    # Local aarch64-linux builder VM, used for building OCI images with dockerTools
    linux-builder.enable = true;
    optimise = {
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 30;
      };
    };
  };

  programs = {
    fish.enable = true;
    nh = {
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
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      PermitRootLogin no
    '';
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

}
