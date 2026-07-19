{ ... }:
{
  catppuccin = {
    autoEnable = true;
    enable = true;
    flavor = "frappe";
    accent = "sapphire";
    # Neovim is configured separately, see github.com/atomicmeganerd/rcd-nvim
    nvim.enable = false;
  };
}
