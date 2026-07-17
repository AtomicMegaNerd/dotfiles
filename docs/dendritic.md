# The Dendritic Flake Pattern

Reference notes on [mightyiam/dendritic](https://github.com/mightyiam/dendritic) — a Nix Flake
module system usage pattern.

## Summary

Every Nix file that isn't an entry point (`flake.nix`, `default.nix`) is a **module of a top-level
configuration**. Each file implements one feature, the file's path is just that feature's name, and
lower-level configs (NixOS, home-manager, nix-darwin) are stored as option values in the top-level
config — not built directly.

## Why it exists

Re-architecting a nix config repeatedly is a known pain. The factors that make it hard (and which
all apply to this repo):

- Multiple host configurations sharing modules — `blahaj` (NixOS) and `Schooner` (darwin) share most
  of `nix/*.nix`.
- Multiple configuration _classes_ that need to coexist — `nixos`, `home-manager`, `darwin`.
- Nesting — on `blahaj`, home-manager is built standalone (`buildHomeMgr`) but conceptually nests
  under NixOS; on `Schooner`, it nests under nix-darwin.
- Cross-cutting features that span multiple config classes — e.g. `git.nix` writes to home-manager,
  but a future `audio.nix` might want to write to both NixOS (`hardware.pulseaudio`) and
  home-manager (`programs.beets`).
- Sharing values (scripts, constants, packages) between files without ugly plumbing — exactly the
  pain that drove us to write `options.amnOptions.flags`.

The dendritic pattern resolves all of these with one trick: treat the whole flake as a single
Nixpkgs module evaluation where every file is a module.

## Core ideas

### 1. There's a top-level configuration, and every file is a module of it

Usually that top-level config is a [flake-parts](https://flake.parts) config, but it doesn't have to
be — `lib.evalModules` works too. Every non-entry-point `.nix` file (everything in `nix/` and
`hosts/`) would be a module of that top-level evaluation — not of NixOS, not of home-manager, of the
_top level_.

### 2. Each file is one feature, across all configs that feature touches

A file's job is to contribute one feature. If `nix/git.nix` needs to set `programs.git` in
home-manager _and_ eventually contribute a NixOS-side option (`environment.etc."gitconfig" = ...`),
all of that lives in the one file. The alternative (splitting a feature across `home/git.nix` and
`nixos/git.nix`) is what produces the proliferation that makes flakes hard to navigate.

### 3. File paths are only feature names

The path `nix/git.nix` says "this file implements the git feature." That's it. The location conveys
no structural meaning — not "this is a home-manager module," not "this belongs to Schooner only."
Consequences:

- Rename or move files freely — paths are just labels.
- Split a file when it grows too big (e.g. `nix/zellij.nix` at ~290 lines is a candidate to split
  out into `nix/zellij/keybinds.nix`).
- Automatic importing: a trivial expression or a small lib like
  [vic/import-tree](https://github.com/vic/import-tree) walks `nix/` and imports everything. No
  `imports = [ ./btop.nix ./catppuccin.nix ... ]` list in `hm_base.nix` to maintain.

### 4. Lower-level configs live in option values

This is the key mechanic. Instead of having `buildHomeMgr` in `flake.nix` assemble the home-manager
module list directly, you declare an option for the storage of those modules:

```nix
# nix/home/base.nix
{ lib, ... }: {
  options.home.base = lib.mkOption {
    type = lib.types.deferredModule;
  };
}
```

Then each existing program file contributes to that named config:

```nix
# nix/git.nix — contributes to the shared home-manager base
{ ... }: {
  config.home.base = {
    programs.git = {
      enable = true;
      settings = { /* ... */ };
    };
  };
}

# nix/btop.nix — contributes to the same base
{ ... }: {
  config.home.base = {
    programs.btop = {
      enable = true;
      settings = { vim_keys = true; };
    };
  };
}
```

Because `deferredModule` supports **value merging**, both files above combine into one home-manager
module under `home.base` — and our `flake.nix` would evaluate `home-manager` with
`modules = [ config.home.base ]` rather than listing each one.

Per-host specialisation is just a second option:

```nix
# nix/home/blahaj.nix — extends the base for the blahaj host
{ config, lib, ... }: {
  options.home.blahaj = lib.mkOption {
    type = lib.types.deferredModule;
  };
  config.home.blahaj = {
    imports = [ config.home.base ];
    home.username = "rcd";
    home.homeDirectory = "/home/rcd";
    home.stateVersion = "22.11";
  };
}

# nix/home/Schooner.nix — extends the base for the Schooner host
{ config, lib, ... }: {
  options.home.Schooner = lib.mkOption {
    type = lib.types.deferredModule;
  };
  config.home.Schooner = {
    imports = [ config.home.base ];
    home.username = "rcd";
    home.homeDirectory = "/Users/rcd";
    home.stateVersion = "24.11";
  };
}
```

No `imports = [ ... ]` list at the host level except one. And no more `hosts/blahaj/rcd.nix` vs
`hosts/Schooner/rcd.nix` boilerplate duplication — each just merges a different `stateVersion` /
`homeDirectory` into the base.

### 5. Shared values go in top-level `config`

If `nix/catppuccin.nix` defines a flavor and accent that other files want to read (e.g. `ghostty.n`
wants to match its terminal theme), they'd read it via `config.catppuccin.flavor` rather than
hardcoding `"frappe"`. They don't receive values through `specialArgs` or `extraSpecialArgs` passed
down through `homeManagerConfiguration` / `nixosSystem`.

## Anti-patterns

These are the parts most worth internalizing — they apply even if you don't adopt the full pattern.

### Not declaring options

Don't just use existing flake-parts storage (`flake.modules.*`) for everything. Declare your own
`deferredModule` options to model how your infra actually fits together. For this repo that's:
`options.home.base`, `options.home.<hostname>`, maybe `options.nixos.<hostname>`,
`options.darwin.<hostname>`. That modeling _is_ the point — it's how you translate your mental model
into code.

### `specialArgs` pass-thru

Passing values from the flake down through `homeManagerConfiguration { ... specialArgs = ...; }` and
then again through nested layers via `extraSpecialArgs` is a known smell. In dendritic every file
can read top-level `config`, so the plumbing disappears.

Our old `import ./fish.nix { inherit flags; }` was a minor version of this same anti-pattern — and
the `let flags = config.amnOptions.flags; in` we just added in each file is only marginally better.
The dendritic version would have `fish.nix` read a top-level option that _any_ file contributes to,
without per-threading `flags` through each module's parameter list.

### Lower-level module name proliferation

Don't give every module a unique name. If you do, import lists balloon
(`imports = with config.home.modules; [ bash bat catppuccin direnv eza fish fzf git ... ]`) and
adding/removing a module means editing every list it belongs in. Instead, merge related modules
under shared names (e.g. `home.base` for "everything both hosts want", `home.mac-only` for "only
Schooner") so a host's config just imports one merged blob.

### Fanaticism

It's a pattern, not a law. Reasonable exceptions are fine — e.g. `static/` files (ssh config, public
key) and `secrets/` agenix files don't need to be modules. They'd be excluded from auto-import by
naming convention (e.g. only `*.nix` files under `modules/`/`nix/` count).

### `enable` options

This one is pointed: `mkEnableOption` / `enable` flags exist because nixpkgs imports most NixOS
modules by default and needs a way to turn features off. In your own flake, **importing a module
should enable the feature** — don't replicate the default-import-then-disable dance.

Practical translation: instead of this current code in `nix/ghostty.nix`:

```nix
{ lib, config, ... }:
let flags = config.amnOptions.flags; in
{
  programs.ghostty = lib.mkIf flags.isMac {
    enable = true;
    settings = { /* ... */ };
  };
}
```

…imported by `hm_base.nix` on _both_ hosts but squashed to nothing on `blahaj`, you'd drop the
`mkIf` and just enable ghostty:

```nix
# nix/ghostty.nix
{ ... }: {
  programs.ghostty = {
    enable = true;
    settings = { /* ... */ };
  };
}
```

…and only import it where you want it (`hm_base.nix` would stop importing `ghostty.nix`; a new
host-specific module like `nix/home/schooner-only.nix` would import it). The host's import list
decides what's present, not a runtime flag. Per the README, this is preferred.

Same applies to `opencode.nix` — drop the `mkIf flags.isMac`, gate by composition.

## Where this repo sits relative to dendritic

The recent refactor (`programs.<name> = { ... }` inside each file, imported via `imports = [ ... ]`)
is most of the way there. What's left if you wanted to go all-in:

1. Adopt `flake-parts` (or `lib.evalModules` directly) so files auto-import — drop the manual
   `imports = [ ./btop.nix ./catppuccin.nix ... ]` list in `hm_base.nix`.
2. Replace `options.amnOptions.flags.isMac` gate with per-host imports — `nix/ghostty.nix` and
   `nix/opencode.nix` would just declare the feature, and `hosts/blahaj/rcd.nix` simply wouldn't
   import them. Per the README this is preferred.
3. Use `deferredModule` so modules from different files merge under named configs (e.g. `home.base`
   as shown above), killing the remaining imports-list maintenance at the host level.

None of this is required. The current refactor already buys the locality benefit: each file is one
feature, gated or not.

## Concepts & vocabulary

- **Module system** — Nixpkgs' mechanism for composing config. A module is a function
  `{ config, lib, pkgs, ... }: { options = ...; config = ...; }`. The `imports` list is how you pull
  modules in; merging happens automatically for known option types.
- **`options`** — what a module declares as configurable. `lib.mkOption` with a `type` determines
  how multiple modules contributing values get merged (list concat, attrset merge, etc).
- **`config`** — the final merged values. What you read when you write `config.home.base`. Writing
  `config = { ... };` in a module contributes to those values.
- **`lib.evalModules`** — the low-level function that runs the module system. `nixosSystem`,
  `homeManagerConfiguration`, `darwinSystem` are wrappers around it. Calling it yourself lets you
  build a "top-level" config not tied to any one of those targets.
- **`deferredModule`** — an option type that stores module _bodies_ (not their evaluated output).
  Multiple files can contribute modules under the same option name, and they merge when the
  containing config (e.g. home-manager) is eventually evaluated. This is what enables "multiple
  files contribute to one named lower-level config."
- **flake-parts** — a flake utility that exposes flake outputs (`nixosConfigurations`,
  `homeConfigurations`, etc.) as module-system options. Convenient way to make the dendritic
  top-level config be your flake itself.
- **`specialArgs` / `extraSpecialArgs`** — args passed into a lower-level module evaluation (e.g.
  into `homeManagerConfiguration`). The dendritic pattern avoids these because every file already
  has access to top-level `config`. We already feel this when `flake.nix` has to thread `agenix`
  into `home-manager` via an inline `{ home.packages = ...; }` module — that'd just be
  `config.agenix.package` readable anywhere.

## Links

- Repo: <https://github.com/mightyiam/dendritic>
- Author's own infra as a real example: <https://github.com/mightyiam/infra>
- Auto-import lib: <https://github.com/vic/import-tree>
- Discourse thread that spawned it: "How do you structure your NixOS configs?"
  <https://discourse.nixos.org/t/how-do-you-structure-your-nixos-configs/65851>
- Matrix: `#dendritic:matrix.org`
