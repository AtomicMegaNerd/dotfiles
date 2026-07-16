# Home Manager Configuration

Reference information on [Home Manager](https://github.com/nix-community/home-manager)

## DAG Ordering for Ordered Settings

Some applications (like OpenCode) use JSON objects where key order matters for evaluation. For
example, OpenCode's permission rules use "last matching rule wins" semantics.

To deal with this Home Manager provides `lib.hm.dag.entryAfter` to enforce ordering:

```nix
external_directory = {
  "~/.config/fish/**" = "allow";
  "~/.config/fish/conf.d/credentials.fish" = lib.hm.dag.entryAfter [ "~/.config/fish/**" ] "deny";
};
```

When any sibling in an attribute set uses DAG ordering, the entire set gets topologically sorted.
