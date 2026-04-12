#!/bin/bash
# =============================================================================
# Chezmoi Bootstrap Script
# =============================================================================
# Idempotent — safe to run on first install or to re-apply after updates.
#
# What it does:
#   1. apt install curl git  (only prerequisites chezmoi can't install itself)
#   2. Creates ~/.config/chezmoi/chezmoi.toml if missing
#   3. Installs chezmoi binary if missing
#   4. Clones withfries2/dotfiles if not already present
#   5. Runs run_once_* scripts (packages, starship, binaries, git config, default shell)
#   6. Deploys all dotfiles (.zshrc, .aliases, starship.toml, etc.)
# =============================================================================

set -euo pipefail

# Handle sudo when running as root (common on Proxmox/LXC)
sudo() {
  if [ "$EUID" -eq 0 ]; then
    "$@"
  else
    command sudo "$@"
  fi
}

echo "=== Bootstrap chezmoi ==="

# -----------------------------------------------------------------------------
# 1. Minimal system deps
# -----------------------------------------------------------------------------
if [[ -f /etc/debian_version ]]; then
  echo "→ Installing minimal deps (Debian)..."
  sudo apt-get update -qq
  sudo apt-get install -y curl git
fi

# -----------------------------------------------------------------------------
# 2. chezmoi.toml — create if missing
# -----------------------------------------------------------------------------
CHEZMOI_CONFIG="$HOME/.config/chezmoi/chezmoi.toml"
if [ ! -f "$CHEZMOI_CONFIG" ]; then
  echo "→ Creating $CHEZMOI_CONFIG with server defaults..."
  mkdir -p "$HOME/.config/chezmoi"
  cat > "$CHEZMOI_CONFIG" << 'EOF'
[data]
    role = "server"
    osid = "debian"
    is_wsl = false
    name = "Frank Chen"
    email = "frank.chen@gmail.com"
EOF
  echo "  ✓ Created. Edit $CHEZMOI_CONFIG to change role/osid before applying."
else
  echo "→ $CHEZMOI_CONFIG already exists, skipping."
fi

# -----------------------------------------------------------------------------
# 3. Install chezmoi binary if missing
# -----------------------------------------------------------------------------
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

if ! command -v chezmoi &> /dev/null; then
  echo "→ Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi
echo "  chezmoi $(chezmoi --version | awk '{print $3}')"

# -----------------------------------------------------------------------------
# 4. Init repo if not already cloned
# -----------------------------------------------------------------------------
if [ ! -d "$HOME/.local/share/chezmoi/.git" ]; then
  echo "→ Cloning withfries2/dotfiles..."
  chezmoi init withfries2/dotfiles
else
  echo "→ Repo already present, pulling latest..."
  chezmoi update --no-tty 2>/dev/null || true
fi

# -----------------------------------------------------------------------------
# 5. Run install scripts (run_once: packages, binaries, git config)
# -----------------------------------------------------------------------------
echo "→ Running install scripts..."
chezmoi apply --include=scripts --verbose

# -----------------------------------------------------------------------------
# 6. Deploy all dotfiles (.zshrc, .aliases, starship.toml, ssh/config, etc.)
# -----------------------------------------------------------------------------
echo "→ Deploying dotfiles..."
chezmoi apply --verbose

echo ""
echo "=== Bootstrap complete ==="
echo "  Run 'exec zsh' or open a new session to start using your shell."
