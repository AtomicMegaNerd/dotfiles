{ self, inputs }:
{
  imports = [
    inputs.nix-darwin.flakeModules.darwin
  ];

  # The rest of the core config
}
