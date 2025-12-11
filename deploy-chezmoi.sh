#!/bin/bash
set -euo pipefail

# Handle sudo when running as root
sudo() {
  if [ "$EUID" -eq 0 ]; then
    "$@"
  else
    command sudo "$@"
  fi
}

echo "=== Bootstrap chezmoi ==="

# 1. Minimal deps for chezmoi
if [[ -f /etc/debian_version ]]; then
  echo "Installing minimal deps (Debian)..."
  sudo apt-get update
  sudo apt-get install -y curl git
fi

# 2. Install chezmoi if missing
if ! command -v chezmoi &> /dev/null; then
  echo "Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /root/.local/bin
fi

export PATH="/root/.local/bin:/usr/local/bin:$PATH"

# 3. Init repo on first run
if [ ! -d /root/.local/share/chezmoi/.git ]; then
  echo "Initializing chezmoi repo..."
  chezmoi init withfries2/dotfiles
fi

# 4. Pull + apply (including scripts)
echo "Updating & applying chezmoi (with scripts)..."
chezmoi update --include=scripts --verbose || true
chezmoi apply --include=scripts --verbose

echo "=== Bootstrap complete ==="
