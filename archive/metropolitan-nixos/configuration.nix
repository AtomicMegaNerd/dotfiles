{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
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
    pulseaudio.enable = false;
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
    xfce.xfce4-settings
    brave
    gnome.adwaita-icon-theme
  ];

  programs = {
    fish.enable = true;
    dconf.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "rcd" ];
    };
    hyprland.enable = true;
    thunar.enable = true;
    xfconf.enable = true;
    steam.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      videoDrivers = [ "amdgpu" ];
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome = { enable = true; };
    };
    flatpak.enable = true;
    blueman.enable = true;
    onedrive.enable = true;
    spice-vdagentd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };

  # 1Password needs this
  security.polkit.enable = true;

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
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
