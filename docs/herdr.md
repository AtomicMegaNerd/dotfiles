# Herdr

Prefix is `C-a` (set in `nix/herdr.nix`). [docs](https://herdr.dev/docs/)

## Daily

| Key               | Action                              |
| ----------------- | ----------------------------------- |
| `herdr`           | attach (creates workspace from cwd) |
| `C-a q`           | detach                              |
| `C-a 1..9`        | switch tab                          |
| `C-a n` / `C-a p` | next / prev tab                     |
| `C-a c`           | new tab                             |
| `C-a T`           | rename tab                          |
| `C-a X`           | close tab                           |
| `C-a N`           | new workspace                       |
| `C-a w`           | workspace picker                    |
| `C-a b`           | toggle sidebar                      |
| `C-a ?`           | all bindings                        |

## CLI

```fish
herdr session list
herdr session attach <name>
herdr workspace create --cwd $PWD --label (basename $PWD)
herdr agent list # what herdr detects
herdr status
```

## Integrations (agent session restore)

```fish
herdr integration install pi
herdr integration install opencode
herdr integration status
```

## After flake switch

```fish
herdr server stop # snapshot persists
herdr # fresh shells, agent conversations resume
```
