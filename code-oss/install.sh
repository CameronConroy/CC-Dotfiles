#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_DOTFILES="$DOTFILES_DIR/code-oss"

echo "==> Installing Code - OSS"
sudo pacman -S --needed code

CODE_BIN="$(command -v code || command -v code-oss)"

echo "==> Restoring Code - OSS configuration"
mkdir -p "$HOME/.config/Code - OSS/User"
mkdir -p "$HOME/.vscode-oss"

for f in settings.json keybindings.json tasks.json locale.json; do
    if [ -f "$CODE_DOTFILES/User/$f" ]; then
        cp "$CODE_DOTFILES/User/$f" "$HOME/.config/Code - OSS/User/$f"
    fi
done

if [ -d "$CODE_DOTFILES/User/snippets" ]; then
    rm -rf "$HOME/.config/Code - OSS/User/snippets"
    cp -a "$CODE_DOTFILES/User/snippets" "$HOME/.config/Code - OSS/User/"
fi

if [ -d "$CODE_DOTFILES/User/profiles" ]; then
    rm -rf "$HOME/.config/Code - OSS/User/profiles"
    cp -a "$CODE_DOTFILES/User/profiles" "$HOME/.config/Code - OSS/User/"
fi

if [ -f "$CODE_DOTFILES/code-flags.conf" ]; then
    cp "$CODE_DOTFILES/code-flags.conf" "$HOME/.config/code-flags.conf"
fi

if [ -f "$CODE_DOTFILES/argv.json" ]; then
    cp "$CODE_DOTFILES/argv.json" "$HOME/.vscode-oss/argv.json"
fi

echo "==> Installing extensions"

while IFS= read -r extension; do
    [ -z "$extension" ] && continue

    echo "Installing $extension"
    "$CODE_BIN" --install-extension "$extension" --force ||
        echo "WARNING: Could not install $extension"
done < "$CODE_DOTFILES/extensions.txt"

echo
echo "Code - OSS setup complete."
