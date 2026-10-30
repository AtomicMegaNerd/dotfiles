{ ... }:
let
  actualBudgetVersion = "26.10.0";
  actualBudgetUid = 890;
  actualBudgetGid = 890;
in
{
  users.groups.actualbudget = {
    gid = actualBudgetGid;
  };
  users.users.actualbudget = {
    uid = actualBudgetUid;
    group = "actualbudget";
    isSystemUser = true;
  };

  virtualisation.oci-containers.containers.actualbudget = {
    autoStart = true;
    image = "actualbudget/actual-server:${actualBudgetVersion}";
    volumes = [ "/var/lib/actualbudget:/data" ];
    environment = {
      TZ = "America/Edmonton";
      ACTUAL_ALLOWED_LOGIN_METHODS = "password";
    };
    extraOptions = [
      "--user=${toString actualBudgetUid}:${toString actualBudgetGid}"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/actualbudget 0750 actualbudget actualbudget -"
  ];
}
