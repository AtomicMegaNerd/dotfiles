# Herdr

Prefix is `C-a` (set in `nix/herdr.nix`). [docs](https://herdr.dev/docs/)

One persistent session; one workspace per project. Detach/reattach keeps processes running. After
`herdr server stop`, snapshot restore rebuilds the layout and agent conversations resume via
integrations.

## Daily

| Key               | Action            |
| ----------------- | ----------------- |
| `herdr`           | attach to session |
| `C-a q`           | detach            |
| `C-a 1..9`        | switch tab        |
| `C-a n` / `C-a p` | next / prev tab   |
| `C-a c`           | new tab           |
| `C-a T`           | rename tab        |
| `C-a X`           | close tab         |
| `C-a N`           | new workspace     |
| `C-a w`           | navigate mode     |
| `C-a g`           | goto picker       |
| `C-a b`           | toggle sidebar    |
| `C-a ?`           | all bindings      |

## Common CLI commands

```fish
herdr session list
herdr session attach $NAME
herdr workspace list
herdr workspace create --cwd $PWD
herdr agent list
herdr status
```

## LLM Agent Integrations

```fish
herdr integration install pi
herdr integration install opencode
herdr integration status
```

## Restart With Fresh Shells

If the shell context is stale we can restart herdr which will start with fresh shells

```fish
herdr server stop
herdr
```
