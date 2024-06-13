{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {

  wsl = {
    enable = true;
    defaultUser = "rcd";
    wslConf = { network.hostname = "metropolitan"; };
  };

  users = {
    users.rcd = {
      isNormalUser = true;
      description = "Chris Dunphy";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [ rcd_pub_key ];
    };
  };

  programs.fish.enable = true;

  virtualisation.containers.enable = true;
  virtualisation = {

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [ neovim git curl podman-compose ];

  nix = {
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

  system.stateVersion = "23.11";
}
