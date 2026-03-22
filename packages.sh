#!/usr/bin/env bash
set -e

if [ "$EUID" -eq 0 ]; then
    echo "Do not run this script as root"
    exit 1
fi

PACMAN_PACKAGES=(
    kitty
    fastfetch
    neovim
    curl
    wget
    zsh
    ranger
    btop
    htop
    vlc
    libreoffice-fresh
    qbittorrent
    code
    ttf-firacode-nerd
    python-black
    clang
    stylua
    wl-clipboard
    nodejs
    npm
    github-cli
)

AUR_PACKAGES=(
    zen-browser-bin
    spotify
    discord
)

if ! command -v yay &>/dev/null; then
    echo "yay not found, installing..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
fi

echo "Updating system..."
sudo pacman -Syyuu --noconfirm

echo "Installing pacman packages..."
sudo pacman -S --needed "${PACMAN_PACKAGES[@]}" --noconfirm

echo "Installing AUR packages..."
yay -S --needed "${AUR_PACKAGES[@]}" --noconfirm

echo "Done!"
