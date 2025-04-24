# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ pkgs, ... }:

{

  wsl = {
	  enable = true;
	  defaultUser = "rcd";
	  wslConf = {
	    network.hostname = "metropolitan";
	  };
  };

     time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

   users = {
    users.rcd = {
      isNormalUser = true;
      description = "Chris Dunphy";
      shell = pkgs.fish;
      extraGroups = [ "wheel" ];
    };
  };

  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
    git-credential-manager
  ];

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
