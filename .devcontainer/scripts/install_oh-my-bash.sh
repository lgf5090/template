#!/bin/bash

# Install oh-my-bash
if [! -d "$HOME/.oh-my-bash" ]; then
  git clone https://github.com/ohmybash/oh-my-bash.git "$HOME/.oh-my-bash"
fi

# Install plugins
if [! -d "$HOME/.oh-my-bash/plugins/git" ]; then
  git clone https://github.com/ohmybash/git.git "$HOME/.oh-my-bash/plugins/git"
fi

