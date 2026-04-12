#!/bin/bash
# =============================================================================
# Chezmoi Bootstrap Script
# =============================================================================
# Idempotent — safe to run on first install or to re-apply after updates.
#
# What it does:
#   1. Creates ~/.config/chezmoi/chezmoi.toml if missing
#   2. Installs chezmoi binary if missing
#   3. Clones withfries2/dotfiles if not already present
#   4. Runs run_once install scripts (packages, binaries, git config)
#   5. Installs starship if missing
#   6. Deploys all dotfiles (.zshrc, .aliases, starship.toml, etc.)
#   7. Sets zsh as the default shell if not already
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
  sudo apt-get install -y curl git zsh
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
# 6. Install starship if missing
# -----------------------------------------------------------------------------
if ! command -v starship &> /dev/null; then
  echo "→ Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
  echo "→ starship $(starship --version | head -1) already installed."
fi

# -----------------------------------------------------------------------------
# 7. Deploy all dotfiles (.zshrc, .aliases, starship.toml, ssh/config, etc.)
# -----------------------------------------------------------------------------
echo "→ Deploying dotfiles..."
chezmoi apply --verbose

# -----------------------------------------------------------------------------
# 8. Set zsh as default shell
# -----------------------------------------------------------------------------
ZSH_PATH=$(command -v zsh)
CURRENT_SHELL=$(getent passwd "$(whoami)" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
  echo "→ Setting default shell to zsh ($ZSH_PATH)..."
  grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
  chsh -s "$ZSH_PATH" "$(whoami)"
  echo "  ✓ Default shell changed. Re-login or 'exec zsh' to apply."
else
  echo "→ Default shell is already zsh."
fi

echo ""
echo "=== Bootstrap complete ==="
echo "  Run 'exec zsh' or open a new session to start using your shell."
