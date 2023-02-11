{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.hostName = "blahaj";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Edmonton";

  users.users.rcd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul"
    ];
  };

  environment.systemPackages = with pkgs;
    [
      # Use stable for the core OS packages
      wget
      curl
      fzf
      ripgrep
      fd
      fish
      exa
      bat
      du-dust
      duf
      htop
      neofetch
      git
      tmux
      gcc12
      gnumake
      rustup
      zip
      unzip
      nixpkgs-fmt
      lua
      go
      rustup
      jq
      python311
      tldr
      grc
      procs

      # Unstable for the following to keep up with the latest
      # these are mostly editors and development tools
      unstable.neovim
      unstable.libuv
      unstable.nushell
      unstable.sumneko-lua-language-server
      unstable.stylua
      unstable.rnix-lsp
      unstable.black
      unstable.pylint
      unstable.mypy
      unstable.pipenv
      unstable.rust-analyzer
      unstable.helix
      unstable.gopls
      unstable.yamllint
      unstable.yarn
      unstable.nodejs
      unstable.nodePackages.typescript
      unstable.nodePackages.prettier
      unstable.nodePackages.pyright
      unstable.nodePackages.bash-language-server
      unstable.nodePackages.yaml-language-server
      unstable.nodePackages.markdownlint-cli
    ];

  # List services that you want to enable:
  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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

}
