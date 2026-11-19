{ ... }:
let
  forgejoVersion = "17.0.1";
  forgejoUid = 891;
  forgejoGid = 891;
  dataDir = "/var/lib/forgejo";
in
{
  users.groups.forgejo.gid = forgejoGid;
  users.users.forgejo = {
    uid = forgejoUid;
    group = "forgejo";
    isSystemUser = true;
  };

  networking.firewall.allowedTCPPorts = [ 2222 ];

  virtualisation.oci-containers.containers.forgejo = {
    autoStart = true;
    image = "codeberg.org/forgejo/forgejo:${forgejoVersion}-rootless";
    user = "${toString forgejoUid}:${toString forgejoGid}";
    ports = [ "2222:2222/tcp" ];
    # The rootless image keeps all of its data in /var/lib/gitea
    volumes = [ "${dataDir}:/var/lib/gitea" ];
    environment = {
      FORGEJO__database__DB_TYPE = "sqlite3";
      FORGEJO__server__DOMAIN = "git.megaparsec.ca";
      FORGEJO__server__ROOT_URL = "https://git.megaparsec.ca/";
      FORGEJO__server__SSH_DOMAIN = "git.megaparsec.ca";
      FORGEJO__server__SSH_PORT = "2222";
      FORGEJO__server__SSH_LISTEN_PORT = "2222";
      FORGEJO__server__START_SSH_SERVER = "true";
      FORGEJO__service__DISABLE_REGISTRATION = "true";
      FORGEJO__actions__ENABLED = "true";
    };
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 ${toString forgejoUid} ${toString forgejoGid} -"
  ];
}
