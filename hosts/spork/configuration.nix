{ config, pkgs, ... }:
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

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.gdm.wayland = true;
    displayManager.gdm.enable = true;
  };
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;
  programs.xwayland.enable = true;

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
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  # Other services
  services.flatpak.enable = true;
  services.onedrive.enable = true;
  services.dbus.enable = true;
  services.spice-vdagentd.enable = true;
  programs.dconf.enable = true;

  # Other core apps
  programs._1password.enable = true;
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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      swaybg
      waybar
      mako
      wl-clipboard
      wf-recorder
      slurp
      xfce.thunar
      xdg-utils
      ulauncher
      blueman
      xwayland
      libinput
      polkit_gnome
      glib
      autotiling
      at-spi2-atk # GTK4 progams expect accessibility protocols
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      export GTK_A11Y=none
    '';
  };
  programs.waybar.enable = true;


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
      neovim
      exa
      ripgrep
      fd
      procs
      jq
      htop
      git
      zip
      unzip
      procs
      firefox
      solaar # Logitech Unifying Receiver

      # fonts
      corefonts
      noto-fonts
      noto-fonts-cjk

      # Virtualization
      virt-manager
      virt-viewer
      win-spice
      win-virtio
      spice-protocol
      spice
      spice-gtk
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
