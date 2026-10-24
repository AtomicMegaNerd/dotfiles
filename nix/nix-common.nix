# Nix settings shared by the NixOS and nix-darwin hosts. The GC schedule differs per
# platform so it stays in the host configs.
{ ... }:
{
  nix = {
    channel.enable = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
