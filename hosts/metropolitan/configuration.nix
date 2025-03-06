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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

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
    shell = pkgs.fish;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    openssh.authorizedKeys.keys = [ rcd_pub_key ];
  };

  programs.fish.enable = true;
  programs.steam.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "rcd" ];
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
  ];

  # GNOME exclusions
  environment.gnome.excludePackages = (with pkgs; [
    gnome-text-editor
    cheese # webcam tool
    epiphany # web browser
    geary # email reader
    gnome-music
    gnome-maps
    gnome-contacts
    gnome-calendar
    snapshot
    gnome-console
    gnome-tour
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
