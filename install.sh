#!/bin/bash
set -e

# Get the dotfiles directory (where this script lives)
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

link_file() {
    local src=$1    # first argument
    local dst=$2    # second argument

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ]; then
        local target=$(readlink "$dst")
        if [ "$target" = "$src" ]; then
            echo -e "\e[33m[SKIP]\e[0m $dst"
        else
            echo -e "\e[31m[WARNING]\e[0m $dst is a symlink pointing to $target"
        fi
    elif [ -f "$dst" ]; then
        echo -e "\e[31m[WARNING]\e[0m $dst already exists as a real file"
    else
        ln -sf "$src" "$dst"
        echo -e "\e[32m[OK]\e[0m Linked $dst"
    fi
}

echo "Installing dotfiles from $DOTFILES_DIR..."

# Kitty config
link_file "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

echo "Installation finished!"
