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
    wget
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

  system.stateVersion = "24.11";
}
