{ nix2container }:
{
  name,
  tag,
  os,
  copyToRoot,
  perms,
  config,
  initializeNixDatabase,
  nixUid,
  nixGid,
}:
nix2container.buildImage {
  inherit
    name
    tag
    perms
    config
    initializeNixDatabase
    nixUid
    nixGid
    ;

  copyToRoot = [
    os.system.path
    os.system.build.etc
  ]
  ++ copyToRoot;
}
