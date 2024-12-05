{ pkgs, ... }:
let rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {

  wsl = {
    enable = true;
    defaultUser = "rcd";
    wslConf = { network.hostname = "metropolitan"; };
  };

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  users = {
    users.rcd = {
      isNormalUser = true;
      description = "Chris Dunphy";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "docker" "podman" ];
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
    };
  };

  environment.systemPackages = (import ../../nix/packages.nix { inherit pkgs; })
    ++ (with pkgs; [ neovim starship git ]);

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  catppuccin = {
    enable = true;
    flavor = "macchiato";
  };

  system.stateVersion = "24.05";
}
