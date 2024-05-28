{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../common/rcd_pub_key;
in {
  imports = [ ./hardware-configuration.nix ];

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
  };
  networking.hostName = "metropolitan";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Edmonton";

  users.users.rcd = {
    isNormalUser = true;
    description = "Chris Dunphy";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ rcd_pub_key ];
  };

  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales =
      [ "en_CA.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
    bluetooth.enable = true;
  };
  sound.enable = true;

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  environment.systemPackages = with pkgs; [
    neovim
    git
    alacritty
    firefox
    walker
    waybar
    mako
    hyprlock
    hyprpaper
    hyprcursor
    hyprpicker
    hypridle
    qt5.qtwayland
    qt6.qtwayland
    qt6.qmake
    adwaita-qt
    adwaita-qt6
    wl-clipboard
    blueman
    pavucontrol
    xdg-utils
    clipman
    catppuccin-gtk
    catppuccin-cursors.frappeTeal
    wl-clipboard
    wl-clip-persist
    themechanger
    xfce.xfce4-settings
    polkit_gnome
    grim
    slurp
    brave
  ];

  programs = {
    fish.enable = true;
    dconf.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "rcd" ];
    };
    hyprland = { enable = true; };
    thunar.enable = true;
    xfconf.enable = true;
    steam.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      videoDrivers = [ "amdgpu" ];
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      catppuccin = {
        enable = true;
        flavor = "frappe";
      };
    };
    flatpak.enable = true;
    onedrive.enable = true;
    dbus.enable = true;
    dbus.packages = with pkgs; [ xfce.xfconf ];
    spice-vdagentd.enable = true;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    tumbler.enable = true;
  };

  # 1Password needs this
  security.polkit.enable = true;

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
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
    settings.auto-optimise-store = true;
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  catppuccin = {
    enable = true;
    flavor = "frappe";
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}

