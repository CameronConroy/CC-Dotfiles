#!/usr/bin/env bash
set -euo pipefail

CODE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Updating Code - OSS dotfiles..."

rm -rf "$CODE_DIR/User"
mkdir -p "$CODE_DIR/User"

for f in settings.json keybindings.json tasks.json locale.json; do
    if [[ -f "$HOME/.config/Code - OSS/User/$f" ]]; then
        cp "$HOME/.config/Code - OSS/User/$f" "$CODE_DIR/User/$f"
    fi
done

if [[ -d "$HOME/.config/Code - OSS/User/snippets" ]]; then
    cp -a "$HOME/.config/Code - OSS/User/snippets" "$CODE_DIR/User/"
fi

if [[ -d "$HOME/.config/Code - OSS/User/profiles" ]]; then
    cp -a "$HOME/.config/Code - OSS/User/profiles" "$CODE_DIR/User/"
fi

# Remove machine-specific state/cache/history, including inside profiles
find "$CODE_DIR/User" -type d \
    \( -name globalStorage -o -name workspaceStorage -o -name History \) \
    -prune -exec rm -rf {} + 2>/dev/null || true

find "$CODE_DIR/User" -type f \
    \( -name 'state.vscdb' -o -name 'state.vscdb.backup' \) \
    -delete 2>/dev/null || true

code --list-extensions | sort > "$CODE_DIR/extensions.txt"
code --list-extensions --show-versions | sort > "$CODE_DIR/extensions-versions.txt"

if [[ -f "$HOME/.config/code-flags.conf" ]]; then
    cp "$HOME/.config/code-flags.conf" "$CODE_DIR/code-flags.conf"
fi

if [[ -f "$HOME/.vscode-oss/argv.json" ]]; then
    cp "$HOME/.vscode-oss/argv.json" "$CODE_DIR/argv.json"
fi

echo "==> Code - OSS dotfiles updated."
