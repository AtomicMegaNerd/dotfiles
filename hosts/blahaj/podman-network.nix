{ pkgs, ... }:
{
  systemd.services.create-podman-network = {
    serviceConfig.Type = "oneshot";
    script = ''
      # Create IPv6 network
      ${pkgs.podman}/bin/podman network exists podman-ipv6 || \
        ${pkgs.podman}/bin/podman network create \
          --driver=bridge \
          --ipv6 \
          --disable-dns \
          --subnet=fd00::/64 \
          --gateway=fd00::1 \
          podman-ipv6
    '';
  };
}
