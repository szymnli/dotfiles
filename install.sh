#!/usr/bin/env bash
set -e

FORCE=false
if [ "$1" = "--force" ]; then
    FORCE=true
fi

OK=0
SKIP=0
WARN=0

# Get the dotfiles directory (where this script lives)
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

link_file() {
    # Dotfiles path
    local src=$1
    # Destination path
    local dst=$2

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ]; then
        local target=$(readlink "$dst")
        if [ "$target" = "$src" ]; then
            # If the symlink already points to the correct file, skip
            echo -e "\033[33m[SKIP]\033[0m $dst"
            ((SKIP++)) || true
        else
            # Symlink exists but points somewhere unexpected
            echo -e "\033[31m[WARNING]\033[0m $dst is a symlink pointing to $target"
            ((WARN++)) || true
        fi
    elif [ -f "$dst" ]; then
        # File exists but is not a symlink
        echo -e "\033[31m[WARNING]\033[0m $dst already exists as a real file"
        if [ "$FORCE" = true ]; then
            mv "$dst" "$dst.backup"
            ln -sf "$src" "$dst"
            echo -e "\033[33m[BACKUP]\033[0m $dst → $dst.backup"
            echo -e "\033[32m[OK]\033[0m Linked $dst"
            ((OK++)) || true
        else
            echo -e "\033[31m[WARNING]\033[0m Use --force to overwrite"
            ((WARN++)) || true
        fi
    else
        # Create symlink
        ln -sf "$src" "$dst"
        echo -e "\033[32m[OK]\033[0m Linked $dst"
        ((OK++)) || true
    fi
}

echo "Installing dotfiles from $DOTFILES_DIR..."

source "$DOTFILES_DIR/files.sh"
for item in "${FILES[@]}"; do
    # Extract source and destination paths
    src=${item%%:*}
    dst=${item#*:}
    link_file "$DOTFILES_DIR/$src" "$dst"
done

echo "Done!"
echo ""
echo "Linked: $OK  Skipped: $SKIP  Warnings: $WARN"
