{ config, lib, ... }:
lib.mkIf (config.amnOptions.theme == "catppuccin") {
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "frappe";
    accent = "sapphire";
    # Neovim is configured separately, see github.com/atomicmeganerd/rcd-nvim
    nvim.enable = false;
  };
}
