{ pkgs, ... }:

let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "arcology";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.rcd = {
    isNormalUser = true;
    description = "Chris Dunphy";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ rcd_pub_key ];
  };

  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  programs = {
    dconf.enable = true;
    firefox.enable = true;
    fish.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "rcd" ];
    };
  };

  services = { openssh.enable = true; };

  virtualisation = {
    containers.enable = true;
    docker = { enable = true; };
    vmware.guest.enable = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-terminal
    gnome-photos
    gnome-tour
    gnome-calendar
    epiphany
    simple-scan
    geary
    totem
    cheese
    gnome-text-editor
    gnome-music
    gnome-contacts
    gnome-maps
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wl-clipboard
    gnomeExtensions.appindicator
    nerd-fonts.jetbrains-mono
    nerd-fonts.departure-mono
    nerd-fonts.caskaydia-cove
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "24.11";
}
