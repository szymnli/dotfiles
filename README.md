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
$ ./install.sh [--force]
$ ./uninstall.sh
$ sudo ./packages.sh
```

## Dotfiles available

Currently this repository contains configuration files for:

- kitty
- fastfetch
  > The config list will be expanded further

## Adding New Dotfiles

1. Create a folder named after the program: `mkdir nvim`
2. Copy your config into it: `cp ~/.config/nvim/init.lua nvim/`
3. Add an entry to `files.sh`:

```bash
  "nvim/init.lua:$HOME/.config/nvim/init.lua"
```

4. Run `./install.sh`
