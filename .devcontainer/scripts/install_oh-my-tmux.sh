#!/bin/bash

# Install oh-my-tmux
if [! -d "$HOME/.oh-my-tmux" ]; then
  git clone https://github.com/gpakosz/.tmux.git "$HOME/.oh-my-tmux"
  ln -s "$HOME/.oh-my-tmux/plugins/tpm" "$HOME/.tmux/plugins/tpm"
fi

