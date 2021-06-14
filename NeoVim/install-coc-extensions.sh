#!/usr/bin/env bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi

# This is the actual COC extensions that we want to install
npm install coc-docker \
    coc-java \
    coc-json \
    coc-markdownlint \
    coc-pyright \
    coc-rust-analyzer \
    coc-toml \
    coc-tsserver \
    coc-yaml \
    --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

