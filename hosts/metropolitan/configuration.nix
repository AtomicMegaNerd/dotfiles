{ pkgs, ... }: {
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
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9DWvFVS2L2P6G/xUlV0yp6gOpqGgCj4dbY91zyT8ul"
      ];
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  programs.fish.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}

