# Code - OSS

My Code - OSS configuration for Arch Linux.

This includes:

* Code - OSS settings
* Keybindings
* Snippets
* Profiles
* Code flags
* Installed extension list
* Automatic installation/restoration script

## Installation

Clone the dotfiles repository:

```bash
git clone git@github.com:CameronConroy/CC-Dotfiles.git
cd CC-Dotfiles
```

Then install and restore Code - OSS:

```bash
./code-oss/install.sh
```

The installer will:

1. Install Code - OSS through `pacman`
2. Restore the Code - OSS user configuration
3. Restore Code flags and `argv.json`
4. Install the extensions listed in `extensions.txt`

## Updating the Dotfiles

After changing Code - OSS settings, extensions, snippets, or profiles, update the saved configuration with:

```bash
./code-oss/update.sh
```

Then commit the changes:

```bash
git add code-oss
git commit -m "Update Code OSS configuration"
git push
```

## Arch Linux

This configuration is intended for Arch Linux and installs Code - OSS using:

```bash
sudo pacman -S --needed code
```
