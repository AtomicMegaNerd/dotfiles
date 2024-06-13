{ pkgs }: {
  enable = true;
  defaultEditor = true;
  vimAlias = true;

  plugins = with pkgs.vimPlugins;
    [
      (nvim-treesitter.withPlugins (p: [
        p.c
        p.lua
        p.nix
        p.go
        p.gomod
        p.rust
        p.haskell
        p.python
        p.typescript
        p.fish
        p.bash
        p.markdown
        p.yaml
        p.toml
        p.zig
        p.hyprlang
      ]))
    ];
}
