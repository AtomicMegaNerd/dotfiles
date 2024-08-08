{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
  };

  # Networking
  networking = {
    hostName = "metropolitan";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  # GUI
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # User Account
  users.users.rcd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "podman" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ rcd_pub_key ];
  };

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  environment.systemPackages = (import ../../nix/packages.nix { inherit pkgs; })
    ++ (with pkgs; [ neovim starship git alacritty firefox ]);

  services.openssh.enable = true;
  programs = {
    fish.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "rcd" ];
    };
  };

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

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "24.05";
}

