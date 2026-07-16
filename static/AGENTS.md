# Global OpenCode Guidance

## Finding information

Do not waste a lot of API tokens searching for information you do not know how to find. Ask me to
find the link to documentation and I can send it to you. Ask questions if it will help to get to the
answer more quickly.

## /tmp is your playground

You are allowed to download anything you want or write any files you want to `/tmp`. Use that to
make your work more efficient.

## CLI tooling

Prefer using CLI tooling.

- Use `gh` to query github and _not_ webfetch. gh is authenticated so we won't hit rate limits.

  Example to get source code:

  ```bash
  gh api repos/nix-community/home-manager/contents/modules/programs/neovim/default.nix \
    -H "Accept: application/vnd.github.raw+json"
  ```

- You have full access to `jq` and many other shell utilities.
- I have installed modern tooling, so please use it. This includes
  - eza
  - bat
  - fd
  - rg (ripgrep)
  - fzf
