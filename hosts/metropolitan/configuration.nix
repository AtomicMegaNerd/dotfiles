{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "metropolitan";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [ pkgs.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };
  };

  hardware.pulseaudio.enable = false;
  hardware.logitech.wireless.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
    };
    extraConfig.pipewire-pulse."92-low-latency" = {
      "context.properties" = [{
        name = "libpipewire-module-protocol-pulse";
        args = { };
      }];
      "pulse.properties" = {
        "pulse.min.req" = "32/48000";
        "pulse.default.req" = "32/48000";
        "pulse.max.req" = "32/48000";
        "pulse.min.quantum" = "32/48000";
        "pulse.max.quantum" = "1024/48000";
      };
      "stream.properties" = {
        "node.latency" = "32/48000";
        "resample.quality" = 1;
      };
    };
  };

  users.users.rcd = {
    isNormalUser = true;
    description = "Chris Dunphy";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "podman" "networkmanager" ];
    openssh.authorizedKeys.keys = [ rcd_pub_key ];
  };

  programs.fish.enable = true;
  programs.steam.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "rcd" ];
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
    git-credential-manager
    wl-clipboard
    bottles
    gnome-tweaks
    gnomeExtensions.appindicator
    solaar
  ];

  # GNOME exclusions
  environment.gnome.excludePackages = (with pkgs; [
    cheese # webcam tool
    epiphany # web browser
    gnome-music
    snapshot
  ]);

  services.openssh.enable = true;
  services.flatpak.enable = true;
  services.gnome.gnome-browser-connector.enable = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes";
  };

  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  system.stateVersion = "24.11";
}
