{ config, lib, ... }:
{
  catppuccin = {
    enable = config.amnOptions.theme == "catppuccin";
    autoEnable = lib.mkIf (config.amnOptions.theme == "catppuccin") true;
    flavor = lib.mkIf (config.amnOptions.theme == "catppuccin") "frappe";
    accent = lib.mkIf (config.amnOptions.theme == "catppuccin") "sapphire";
    # Neovim is configured separately, see github.com/atomicmeganerd/rcd-nvim
    nvim.enable = false;
  };
}
