# Python and C++ IDE

## Install on another Arch machine

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

## Learn these first

Start `nvim` inside your project directory. Space is the leader key: press it
and pause to see commands.

You are always in a mode. Press `Esc` whenever you are unsure; that returns to
Normal mode. From Normal mode:

| Keys | Action |
| --- | --- |
| i | Start typing before the cursor |
| a | Start typing after the cursor |
| Esc | Stop typing and return to Normal mode |
| h j k l | Move left, down, up, right |
| u | Undo |
| Ctrl r | Redo |
| dd | Delete the current line |
| yy / p | Copy the current line / paste it |
| Ctrl s or Space w | Save |
| Space q | Quit the current window; asks before discarding changes |
| F1 | Open this help page |
| F2 | Rename the symbol under the cursor everywhere |
| F4 | Show/hide all lint and compiler problems |
| F6 | Run the current Python, C, or C++ file |
| F7 | Run the test under the cursor |
| F8 | Format the current file |
| Space Space | Find a file by name |
| Space / | Search text in the whole project |
| Space e | Open the file explorer |

`Space` means press the spacebar, release it, then press the next key. You do
not need to hold it. The popup that appears after Space shows the available
commands. Arrow keys and the mouse also work. `:wq` still saves and quits.

Colored text at the end of a line is a diagnostic. Put the cursor on it and
press `Space c d` for the full message, then `Space c a` for available fixes.
Use `]d` and `[d` to move between diagnostics.

Linting, type checking, and completion are automatic. Open a Python or C++
file and start typing; use `Tab` to accept the suggested completion. Problems
appear beside the code as you type. Saving with `Ctrl-s` also formats the file.
You can use `F4` to see every problem in a list.

If you prefer commands like `:wq`, these work too: `:Run`, `:Problems`,
`:Format`, and `:Test`. Type the command and press Enter.

Python has Pyright type checking and navigation, Ruff linting and formatting,
virtual-environment selection, pytest integration, and debugpy debugging.
C++ has clangd completion/navigation, clang-tidy diagnostics, clang-format,
CMake build/run/debug controls, CTest integration, and CodeLLDB debugging.
Both have snippets, automatic bracket/quote pairing, signature help, inline
completion previews, rename, code actions, Git tools, and persistent undo.

The font is `JetBrainsMonoNL Nerd Font:h16` in GUI clients; Kitty already uses
that family at size 16. Colors still come from your Matugen/Quickshell palette,
with transparency and a Tokyo Night fallback if the palette cannot be read.

## Editing and navigation

| Keys | Action |
| --- | --- |
| Tab / Shift Tab | Accept completion / move through snippet fields |
| Enter | Accept selected completion |
| Ctrl Space | Show completion/documentation |
| Ctrl n / Ctrl p | Next/previous completion |
| Ctrl e | Dismiss completion |
| Ctrl k (insert mode) | Signature help |
| Ctrl s | Save (formats automatically) |
| gd / gr / gI | Definition / references / implementation |
| K | Documentation hover |
| Space c r | Rename symbol across project |
| Space c a | Code actions and quick fixes |
| Space c f | Format |
| Space c n | Generate docstring / documentation comment |
| Space c h | Switch C++ source/header |
| Space c v | Select Python virtual environment |
| Space s s | Symbol outline/search |
| Space x x | Project diagnostics |
| ]d / [d | Next/previous diagnostic |
| Space u f | Toggle format on save |
| Space u h | Toggle inlay hints |
| Space Space | Find files |
| Space / | Search project text |
| Space e | File explorer |
| Space , | Switch buffers |
| Space g g | LazyGit |
| Ctrl / | Terminal |
| Space f C | Edit this Neovim configuration |

Type `cfn` for a function snippet with camelCase placeholders (Python or C++),
`ctest` for a Python camelCase test, or `cmain` for a C++ main function.
Other language snippets are available through completion as well.

## Run, build, debug, and test

| Keys | Action |
| --- | --- |
| F6 | Run Python file / build and run single C or C++ file |
| F5 | Start debugger / continue |
| F9 | Toggle breakpoint |
| F10 / F11 / F12 | Step over / into / out |
| Shift F5 | Stop debugging |
| Space d B | Conditional breakpoint |
| Space d u | Debugger panels (variables, watches, call stack) |
| Space d e | Evaluate expression |
| Space o m | CMake configure |
| Space o b | CMake build |
| Space o s | Select CMake launch target |
| Space o r / Space o d | CMake run / debug |
| Space o o / Space o w | Run task / task list |
| Space t r | Run nearest test |
| Space t t / Space t T | Run tests in file / project |
| Space t d | Debug nearest test |
| Space t s / Space t o | Test summary / output |

F6 compiles single C++ files as C++20 (C files as C17) with debug symbols and
warnings; binaries go in Neovim's cache. Multi-file projects should use CMake
or an Overseer task. CMake exports `compile_commands.json` into `build` so
clangd can read your actual include paths and compiler flags. Existing CMake
presets and project build settings govern full-project builds. For other build
systems, provide `compile_commands.json` or `compile_flags.txt` to clangd.

For Python, run/test uses the selected environment, a project `.venv`, `venv`
or `env`, then Python from PATH. Put `pytest` in the project's development
dependencies to run pytest tests; debugpy itself is installed through Mason.
Neotest accepts `testCamelCase` as well as `test_snake_case` functions. Keep
Python test filenames as `test_*.py` or `*_test.py`. C++ test filenames can use
`something_test.cpp` or `somethingTest.cpp` (also `.cc`/`.cxx`). CTest supports
GoogleTest, Catch2, doctest and CppUTest projects with tests registered in CMake;
configure and build the tests first. Existing `.vscode/launch.json` debug
configurations can also be used.

Ruff allows camelCase functions, arguments, locals, and attributes and checks
imports, common bugs and simplifications. Formatters preserve identifiers.
C++ naming is left to your project; clang-tidy does not impose snake_case by
default. Project formatter files continue to set indentation and layout.

`:Lazy` manages plugins, `:Mason` manages language tools, `:LazyExtras` adds
languages, and `:checkhealth` diagnoses the environment.

Backup before this IDE extension:
`~/.config/nvim.backup-ide-20260909-230349`

[LazyVim configuration reference](https://www.lazyvim.org/configuration)
[LazyVim C++ integration](https://www.lazyvim.org/extras/lang/clangd)

## Install on another Arch machine

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
