# szymnli's dotfiles

Collection of my personal dotfiles. Featuring scripts to install and uninstall them + a script to install my essential packages on an Arch-based system.

## Requirements

- git
- Arch-based Linux (Optional)

## Structure

```
dotfiles/
├── install.sh # symlinks dotfiles to their correct locations
├── uninstall.sh # removes symlinks
├── packages.sh # installs essential packages via pacman and yay
├── files.sh # list of dotfiles to manage
└── <config_dir>
  └── <file.conf>
```

## Installation

To install, clone this repo to `~/.dotfiles` or your preferred directory

```
$ git clone https://github.com/szymnli/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
```

Add execute permissions to the files

```
$ chmod +x install.sh uninstall.sh packages.sh
```

To install, uninstall the dotfiles or install the packages, run their respective scripts. Use flag `--force` if you wish to skip warnings about preexisting configurations being present.

```
$ ./packages.sh
$ ./install.sh [--force]

$ ./uninstall.sh
```

## Post Installation

After running `packages.sh`, authenticate with GitHub CLI:
```
$ gh auth login
```
This is required for git to push/pull from GitHub using your `.gitconfig` credential helper. Remember to change your name and email there.

---

To set zsh as your default shell use the following command.
```
$ chsh -s $(which zsh)
```
Then log out and back in.

## Dotfiles available

Currently this repository contains configuration files for:

- kitty
- fastfetch
- neovim
- zsh
  > The config list will be expanded further

### Neovim

Custom neovim config using lazy.nvim. See the [cheatsheet](nvim/cheatsheet.md) for all keybindings.

## Adding New Dotfiles

1. Create a folder named after the program: `mkdir nvim`
2. Copy your config into it: `cp ~/.config/nvim/init.lua nvim/`
3. Add an entry to `files.sh`:

```bash
FILES=(
    "kitty/kitty.conf:$HOME/.config/kitty/kitty.conf"
    "fastfetch/config.jsonc:$HOME/.config/fastfetch/config.jsonc"
    ...
    "nvim/init.lua:$HOME/.config/nvim/init.lua"  # ← add this
)
```

4. Run `./install.sh`
