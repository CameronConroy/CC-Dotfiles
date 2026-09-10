# Install on another Arch machine

Copy and paste this one command into the laptop's terminal:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/CameronConroy/CC-Dotfiles/main/nvim/install.sh)
```

The installer handles the packages, nvim-only download, backup, and symlink.
The manual commands are below in case they are ever needed.

Install the system tools and matching font:

```sh
sudo pacman -S --needed neovim git ripgrep fd fzf lazygit clang cmake ninja \
  python ttf-jetbrains-mono-nerd
```

Use a sparse clone so Git checks out only the Neovim directory, then link it
into Neovim's standard location:

```sh
git clone --filter=blob:none --sparse \
  https://github.com/CameronConroy/CC-Dotfiles.git \
  ~/.local/share/nvim-config
git -C ~/.local/share/nvim-config sparse-checkout set nvim
mkdir -p ~/.config
[ -e ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup
ln -s ~/.local/share/nvim-config/nvim ~/.config/nvim
nvim
```

The first Neovim launch downloads plugins and language tools. Update later
with `git -C ~/.local/share/nvim-config pull`. Matugen colors are used when
`~/.config/hypr/scripts/quickshell/qs_colors.json` exists; otherwise the editor
safely falls back to Tokyo Night.
