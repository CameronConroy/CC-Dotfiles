# CC Dotfiles

## Install only Neovim on Arch Linux

Open this repository on the laptop, then copy and paste this one command into
the terminal:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/CameronConroy/CC-Dotfiles/main/nvim/install.sh)
```

The installer downloads only the `nvim` directory, installs the required Arch
packages, backs up an existing Neovim configuration, and creates the correct
link. When it finishes, start the editor with:

```sh
nvim
```

Press `F1` inside Neovim for the beginner guide. The full configuration and
manual installation instructions are in [nvim/README.md](nvim/README.md).
