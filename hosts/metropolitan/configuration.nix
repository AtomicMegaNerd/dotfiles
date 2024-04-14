# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "quiet" ];
    loader.systemd-boot.enable = true;
    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    # Plymouth
    plymouth.enable = true;
    plymouth.theme = "breeze";
  };
  networking.hostName = "metropolitan"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Edmonton";

  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales =
      [ "en_CA.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
    };
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    displayManager.gdm.wayland = true;
    displayManager.gdm.enable = true;
  };
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;

  # Logitech
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Virtualization and Containers
  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
  };

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  # Users
  users.users.rcd = {
    isNormalUser = true;
    description = "Chris Dunphy";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul"
    ];
  };

  # Default packages
  environment.systemPackages = with pkgs; [
    git
    alacritty
    firefox
    wofi
    waybar
    mako
    hyprlock
    hyprpaper
    hyprpicker
    hypridle
    qt5.qtwayland
    qt6.qtwayland
    qt6.qmake
    adwaita-qt
    adwaita-qt6
    wl-clipboard
  ];

  # Other services
  services.flatpak.enable = true;
  services.onedrive.enable = true;
  services.dbus.enable = true;
  services.spice-vdagentd.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Polkit
  security.polkit.enable = true;

  programs.fish.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "rcd" ];
  programs.hyprland = { enable = true; };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  system.stateVersion = "23.11"; # Did you read the comment?

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}

