#!/usr/bin/env bash
set -euo pipefail

repo_url="https://github.com/CameronConroy/CC-Dotfiles.git"
repo_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim-config"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

echo "Installing Neovim and IDE dependencies..."
sudo pacman -S --needed --noconfirm \
  neovim git ripgrep fd fzf lazygit clang cmake ninja python nodejs npm \
  tree-sitter-cli unzip wl-clipboard ttf-jetbrains-mono-nerd

if [[ -d "$repo_dir/.git" ]]; then
  echo "Updating the existing Neovim configuration..."
  git -C "$repo_dir" sparse-checkout set nvim
  git -C "$repo_dir" pull --ff-only
elif [[ -e "$repo_dir" ]]; then
  echo "Cannot install: $repo_dir exists but is not the config repository." >&2
  exit 1
else
  echo "Downloading only the Neovim configuration..."
  mkdir -p "$(dirname "$repo_dir")"
  git clone --filter=blob:none --sparse "$repo_url" "$repo_dir"
  git -C "$repo_dir" sparse-checkout set nvim
fi

mkdir -p "$(dirname "$config_dir")"
if [[ -e "$config_dir" || -L "$config_dir" ]]; then
  if [[ "$(readlink -f "$config_dir")" != "$(readlink -f "$repo_dir/nvim")" ]]; then
    backup="${config_dir}.backup-$(date +%Y%m%d-%H%M%S)"
    mv "$config_dir" "$backup"
    echo "Existing Neovim config backed up to $backup"
  fi
fi

if [[ ! -e "$config_dir" && ! -L "$config_dir" ]]; then
  ln -s "$repo_dir/nvim" "$config_dir"
fi

echo
echo "Installed successfully. Run: nvim"
echo "Press F1 inside Neovim for the beginner guide."
