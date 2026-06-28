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

  services.paneru = {
    enable = true;
    # Paneru configuration
    # See CONFIGURATION.md for a list of all options
    settings = {

      options = {
        focus_follows_mouse = false;
        mouse_follows_focus = true;
        auto_center = true;
        preset_column_widths = [
          0.25
          0.33
          0.5
          0.66
          0.75
          1.0
        ];
        animation_speed = 15;
      };

      decorations = {
        workspace_menu_status = false;
        workspace_popup_status = false;
      };

      bindings = {
        window_focus_west = "cmd - h";
        window_focus_east = "cmd - l";
        window_resize = "alt - r";
        window_center = "alt - c";
        quit = "ctrl + alt - q";
      };

      windows = {
        all = {
          title = ".*";
          horizontal_padding = 5;
        };

        ghostty = {
          title = ".*";
          bundle_id = "com.mitchellh.ghostty";
          width = 1.0;
        };
      };

      padding = {
        bottom = 5;
        top = 5;
        left = 5;
        right = 5;
      };
    };
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
      extraFlags = [
        "--force-cleanup"
      ];
    };
    casks = [
      "1password" # gui password manager
      "1password-cli" # cli password manager
      "raycast" # launcher
      "zoom" # video meetings
      "calibre" # managing ebooks
      "linearmouse" # better logitech mouse settings
      "finetune" # per-app volume control
      "zed" # text editor
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
