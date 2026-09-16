#!/bin/bash
set -euo pipefail

# --- Hyprland + System Dependencies ---
sudo pacman -S --needed \
    hyprland \
    hyprpaper \
    hyprlock \
    hypridle \
    hyprpicker \
    hyprsunset \
    xdg-desktop-portal \
    xdg-desktop-portal-hyprland \
    hyprpolkitagent \
    xorg-xwayland \
    qt5-wayland \
    qt6-wayland \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    wl-clipboard \
    iwd \
    bluez \
    bluez-utils \
    networkmanager \
    ttf-jetbrains-mono-nerd \
    fontconfig \
    mesa \
    vulkan-radeon \
    lib32-mesa \
    git \
    base-devel

# Enable services
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now pipewire
sudo systemctl enable --now pipewire-pulse

# --- AUR Helper ---
if ! command -v yay &>/dev/null; then
    cd /tmp
    git clone --depth 1 https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd ~ && rm -rf /tmp/yay
fi

# --- App Packages ---
sudo pacman -S --needed $(cat requirements.txt)
yay -S --needed $(cat aur.txt)

# --- Dotfiles ---
DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone https://github.com/CameronConroy/CC-Dotfiles.git "$DOTFILES_DIR"
fi

# Symlink config folders
declare -A LINKS=(
    ["hypr"]="hypr"
    ["btop"]="btop"
    ["cava"]="cava"
    ["gtk-3.0"]="gtk-3.0"
    ["kitty"]="kitty"
    ["matugen"]="matugen"
    ["nvim"]="nvim"
    ["quickshell"]="quickshell"
    ["rofi"]="rofi"
    ["swaync"]="swaync"
    ["zsh"]="zsh"
)

for src in "${!LINKS[@]}"; do
    target="$HOME/.config/${LINKS[$src]}"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Skipping (exists): $target"
    else
        rm -rf "$target"
        ln -s "$DOTFILES_DIR/$src" "$target"
        echo "Linked: $src → $target"
    fi
done

# Symlink .zshrc
if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "Skipping (exists): $HOME/.zshrc"
else
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
fi

# --- Wallpaper + Matugen ---
WALLPAPER="$HOME/Wallpapers/Tlou Trailer.jpg"
mkdir -p "$HOME/Wallpapers"

# (Copy wallpaper if it's in the repo)
if [ -f "$DOTFILES_DIR/wallpapers/Tlou Trailer.jpg" ]; then
    cp "$DOTFILES_DIR/wallpapers/Tlou Trailer.jpg" "$WALLPAPER"
fi

matugen image "$WALLPAPER"

# --- Post-install ---
chsh -s "$(which zsh)"

echo "Done. Log out and back in to start Hyprland."   
