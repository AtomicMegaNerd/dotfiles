{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the latest Linux kernel
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "quiet" ];
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/";
    # Plymouth
    plymouth.enable = true;
    plymouth.theme = "breeze";
  };

  # Networking
  networking.hostName = "spork";
  networking.networkmanager.enable = true;

  # Time
  time.timeZone = "America/Edmonton";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales = [
      "en_CA.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
    };
  };

  # Enable Wayland and XWayland with the nVidia drivers
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "us";
    xkbVariant = "";
    displayManager.gdm.wayland = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  programs.xwayland.enable = true;

  # Virtualization and Containers
  virtualisation = {
    docker.enable = true;
  };

  # Other services
  services.flatpak.enable = true;
  services.onedrive.enable = true;

  # Other core apps
  programs.dconf.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "rcd" ];
  programs.steam.enable = true;

  # Setup fonts
  fonts = {
    fontDir.enable = true;
    # Can't live without nerd fonts!
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
  };

  # Enable the GNOME Desktop Environment.
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-calendar
    gnome-contacts
  ]);


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Local user configuration
  users.users.rcd = {
    isNormalUser = true;
    description = "Chris Dunphy";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs;
    [
      # Use stable for the core OS packages
      wget
      curl
      fish
      htop
      git
      zip
      unzip
      procs
      firefox
      fd
      rustup

      # fonts
      corefonts
      noto-fonts
      noto-fonts-cjk

      # GNOME specific
      gnome.gnome-tweaks
      gnomeExtensions.pop-shell
      gnomeExtensions.appindicator
    ];


  # Configure our setup to auto-upgrade and also clean up older versions we no longer
  # need. This will save on disk space.
  system.autoUpgrade = {
    enable = true;
    channel = "https:nixos.org/channels/nixos-22.11";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
