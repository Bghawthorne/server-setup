#!/bin/bash
# Lightsail Docker + Portainer Setup Script (Safe for $5 plan)

# Exit on error
set -e

echo "==== Updating system ===="
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "==== Adding Docker GPG key ===="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "==== Adding Docker repository ===="
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==== Installing Docker Engine + Compose plugin ===="
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==== Adding user to Docker group ===="
sudo usermod -aG docker $USER

echo "==== Creating 1GB swapfile (critical for $5 plan) ===="
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
free -h

echo "==== Stopping any existing Portainer ===="
sudo docker stop portainer 2>/dev/null || true
sudo docker rm portainer 2>/dev/null || true

echo "==== Creating Portainer volume ===="
sudo docker volume create portainer_data

echo "==== Running Portainer CE with resource limits ===="
sudo docker run -d \
  --name portainer \
  --restart=always \
  --memory=256m \
  --cpus=0.5 \
  -p 9000:9000 \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo "==== Setup complete! ===="
echo "Portainer UI:"
echo "  HTTP  : http://<your-lightsail-ip>:9000"
echo "  HTTPS : https://<your-lightsail-ip>:9443"
echo ""
echo "Swap setup"
swapon --show
echo "Note: You may need to log out and back in for Docker group permissions to take effect."
