{ inputs, ... }: {
  imports = [
    # adds home-manager options to flake-parts
    inputs.home-manager.flakeModules.home-manager
  ];

  # The rest of the core config
}
