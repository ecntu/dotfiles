#!/usr/bin/env bash
set -euo pipefail

# Simple installer: remove common conflicting dotfiles, then stow.
# Usage: bash install.sh

TARGET="${TARGET:-$HOME}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
  "$TARGET/.config/tmux/.tmux.conf" \
  "$TARGET/.config/ghostty/config" || true

echo "Stowing dotfiles into $TARGET"
cd "$REPO_DIR"
stow -vt "$TARGET" home

echo "Done."
