#!/usr/bin/env bash
set -e

DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

REMOVED=0
SKIP=0
WARN=0

unlink_file() {
    local src=$1
    local dst=$2

    if [ -L "$dst" ]; then
        local target=$(readlink "$dst")
        if [ "$target" = "$src" ]; then
            rm "$dst"
            echo -e "\033[32m[REMOVED]\033[0m $dst"
            ((REMOVED++)) || true
        else
            # Symlink exists but points somewhere else
            echo -e "\033[31m[WARNING]\033[0m $dst points to $target, skipping"
            ((WARN++)) || true
        fi
    elif [ -f "$dst" ]; then
        # Real file
        echo -e "\033[33m[SKIP]\033[0m $dst is a real file, not a symlink"
        ((SKIP++)) || true
    else
        # Nothing there at all
        echo -e "\033[33m[SKIP]\033[0m $dst does not exist"
        ((SKIP++)) || true
    fi
}

echo "Uninstalling dotfiles..."

source "$DOTFILES_DIR/files.sh"

for item in "${FILES[@]}"; do
    # Extract source and destination paths
    src=${item%%:*}
    dst=${item#*:}
    unlink_file "$DOTFILES_DIR/$src" "$dst"
done

echo ""
echo "Removed: $REMOVED  Skipped: $SKIP  Warnings: $WARN"
echo "Done!"
