{ pkgs, ... }:
let
  piholeUid = 888;
  piholeGid = 888;
  rcd_pub_key = builtins.readFile ../../static/rcd_pub_key;
in {

  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "blahaj";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8080 8081 53 ];
    firewall.allowedUDPPorts = [ 53 ];
    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
    interfaces.enp0s31f6 = { useDHCP = true; };
  };

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  users = {
    users.rcd = {
      isNormalUser = true;
      description = "Chris Dunphy";
      extraGroups = [ "wheel" "docker" "podman" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [ rcd_pub_key ];
    };
    groups.pihole = { gid = piholeGid; };
    users.pihole = {
      isSystemUser = true;
      uid = piholeUid;
      group = "pihole";
    };
  };

  systemd.tmpfiles.rules = [
    "Z /etc/pihole 0775 ${toString piholeUid} ${toString piholeGid} -"
    "Z /etc/dnsmasq.d 0775 ${toString piholeUid} ${toString piholeGid} -"
  ];

  virtualisation.containers.enable = true;
  virtualisation = {
    docker = { enable = true; };
    oci-containers = {
      backend = "docker";
      containers = {
        pihole = {
          user = "root";
          autoStart = true;
          image = "pihole/pihole:2024.07.0";
          ports = [ "53:53/tcp" "53:53/udp" "8081:80/tcp" ];
          volumes =
            [ "/etc/pihole:/etc/pihole" "/etc/dnsmasq.d:/etc/dnsmasq.d" ];
          environment = {
            TZ = "America/Edmonton";
            FTLCONF_LOCAL_IPV4 = "192.168.1.232";
            FTLCONF_LOCAL_IPV6 = "2604:3d09:676:2d40:6e4b:90ff:fe4f:bed4";
            PIHOLE_UID = toString piholeUid;
            PIHOLE_GID = toString piholeGid;
            BLOCK_ICLOUD_PR = "false";
          };
        };
        freshrss = {
          autoStart = true;
          image = "freshrss/freshrss:latest";
          ports = [ "8080:80/tcp" ];
          volumes = [
            "freshrss_data:/var/www/FreshRSS/data"
            "fresrss_extensions:/var/www/FreshRSS/extensions"
          ];
          environment = { TZ = "America/Edmonton"; };
        };
      };
    };
  };

  environment.systemPackages = (import ../../nix/packages.nix { inherit pkgs; })
    ++ (with pkgs; [ neovim starship git dig ]);

  services.openssh.enable = true;
  programs.fish.enable = true;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "23.11";
}
