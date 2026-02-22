#!/usr/bin/env bash
set -euo pipefail

# Simple installer: remove common conflicting dotfiles, then stow.
# Usage: bash install.sh

TARGET="${TARGET:-$HOME}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

STOW_FOLDERS=("home" "vim" "tmux" "custom_bins")

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
  "$TARGET/.gitconfig" \
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

# Ensure ~/.ssh/config includes boxes config
SSH_CONFIG="$TARGET/.ssh/config"
BOXES_INCLUDE="Include ~/.ssh/boxes/config"
mkdir -p "$TARGET/.ssh/boxes"
touch "$SSH_CONFIG"
if ! grep -qF "$BOXES_INCLUDE" "$SSH_CONFIG"; then
  # Include must be at the top of ssh config
  printf '%s\n\n%s' "$BOXES_INCLUDE" "$(cat "$SSH_CONFIG")" > "$SSH_CONFIG"
  echo "Added boxes Include to $SSH_CONFIG"
fi

echo "Done."
