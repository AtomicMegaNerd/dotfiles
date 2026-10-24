# Nix settings shared by the NixOS and nix-darwin hosts. Garbage collection differs per
# platform so it lives in the host configs.
{ ... }:
{
  nix = {
    channel.enable = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
