#!/bin/bash

# Exit on error
set -e

# Add nano 
echo "Installing Nano"
sudo apt install nano

# Generate SSH key (replace with your email)
echo "Generating SSH(Key/Pair)"
ssh-keygen -t ed25519 -C "hawthornebrian2013@gmail.com" -f ~/.ssh/id_ed25519 -N ""

# Display public key (so you can add it to GitHub/GitLab)
echo "Your public key is:"
cat ~/.ssh/id_ed25519.pub
echo "Copy this key to your Git hosting service (GitHub, GitLab, etc.)."

# Set Git global configs
git config --global user.name "bghawthorne"
git config --global user.email "hawthornebrian2013@gmail.com"
git config --global core.editor "nano"   

echo "Setup Complete"




