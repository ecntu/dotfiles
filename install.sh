#!/usr/bin/env bash
set -euo pipefail

# Simple installer: remove common conflicting dotfiles, then stow.
# Usage: bash install.sh

TARGET="${TARGET:-$HOME}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

STOW_FOLDERS=("home" "vim" "tmux" "ghostty" "custom_bins")

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU stow not found. Please install it and re-run." >&2
  exit 1
fi

echo "Removing potential conflicts from $TARGET"
rm -f \
  "$TARGET/.bashrc" \
  "$TARGET/.bash_profile" \
  "$TARGET/.aliases" \
  "$TARGET/.functions" \
  "$TARGET/.gitignore_global" \
  "$TARGET/.zshrc" \
  "$TARGET/.vimrc" \
  "$TARGET/.tmux.conf" \
  "$TARGET/.config/tmux/.tmux.conf" \
  "$TARGET/.config/ghostty/config" || true

cd "$REPO_DIR"
for folder in "${STOW_FOLDERS[@]}"; do
  echo "Stowing dotfiles into $TARGET"
  stow -D -t "$TARGET" "$folder" || true
  stow -vt "$TARGET" "$folder"
done

echo "Done."
