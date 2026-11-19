# Neovim

The shared Neovim configuration is in [`static/common/nvim`](../../static/common/nvim/). It is
deployed to `~/.config/nvim` by Home Manager on Nix-managed systems. On `workmbp`, create a symlink
to that directory manually:

```sh
ln -s ~/Code/Configs/dotfiles/static/common/nvim ~/.config/nvim
```

The repository-root `mise.toml` declares the non-Nix tooling used by the configuration. From the
dotfiles repository root, trust the project and install its tools:

```sh
mise trust
mise install
```

## Plugin management

Plugins are managed with Neovim's built-in `vim.pack`. They are imported in `lua/pack.lua` and
configured in the `plugin` directory (one file per plugin).

See the [vim.pack guide](https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack.html).

### Updating plugins

After opening Neovim, run this in command mode:

```vim
:lua vim.pack.update()
```

This opens a confirmation buffer showing what will change. Write the buffer to confirm, or close it
to cancel. The `<leader>pu` mapping runs the same command.

### Removing a plugin

1. Remove the entry from `lua/pack.lua`.
2. In Neovim, remove it from disk:

   ```lua
   :lua vim.pack.del({ 'plugin-name' })
   ```

Do not delete plugin directories manually; that leaves `nvim-pack-lock.json` out of sync.
