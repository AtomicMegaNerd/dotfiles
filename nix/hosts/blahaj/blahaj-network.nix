{
  podmanNetwork = {
    ipv6_enabled = true;
    subnets = [
      {
        subnet = "10.88.0.0/16";
        gateway = "10.88.0.1";
      }
      {
        subnet = "fd00::/64";
        gateway = "fd00::1";
      }
    ];
  };

  microVmNet = {
    bridge = "vm-bridge";
    tapPrefix = "vm-tap-";
    v4 = rec {
      base = "10.77.0";
      prefixLength = 24;
      host = "${base}.1";
      hostCidr = "${host}/${toString prefixLength}";
      guestCidr = index: "${base}.${toString index}/${toString prefixLength}";
    };
    v6 = rec {
      base = "fd77::";
      prefixLength = 64;
      host = "${base}1";
      hostCidr = "${host}/${toString prefixLength}";
      guestCidr = index: "${base}${toString index}/${toString prefixLength}";
    };
  };
}
