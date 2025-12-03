#!/bin/bash
# Deploy chezmoi dotfiles to a server
# Usage: curl -fsSL https://raw.githubusercontent.com/withfries2/dotfiles/main/deploy-chezmoi.sh | bash -s <hostname>

HOSTNAME=${1:-$(hostname)}

echo "=== Deploying chezmoi to $HOSTNAME ==="

# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Create config
mkdir -p ~/.config/chezmoi ~/.local/bin
cat > ~/.config/chezmoi/chezmoi.toml << EOC
[data]
    role = "server"
    hostname = "$HOSTNAME"
    display = ""
    keyboard = ""
EOC

# Initialize and apply
./bin/chezmoi init --apply withfries2

# Move to proper location
mv ./bin/chezmoi ~/.local/bin/

echo ""
echo "=== Deployment complete! ==="
echo "Run: source ~/.bashrc"
echo "Then test: cm --version"
