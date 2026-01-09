#!/bin/bash
set -e

USER_NAME="shiva"
SERVICES_DIR="/home/$USER_NAME/services"
USB_MOUNT="/media/$USER_NAME"
BACKUP_DIR="services"

echo -e "\e[34m=== STEP 1: System update ===\e[0m"
sudo apt update
sudo apt upgrade -y

echo -e "\e[34m=== STEP 2: Install basic deps ===\e[0m"
sudo apt install -y curl ca-certificates gnupg lsb-release rsync

echo -e "\e[34m=== STEP 3: Install Docker (if missing) ===\e[0m"
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker $USER_NAME
else
  echo -e "\e[33mDocker already installed\e[0m"
fi

echo -e "\e[34m=== STEP 4: Enable Docker ===\e[0m"
sudo systemctl enable --now docker

echo -e "\e[34m=== STEP 5: Verify docker compose ===\e[0m"
if ! docker compose version >/dev/null 2>&1; then
  echo -e "\e[33mDocker Compose plugin missing\e[0m"
  exit 1
else
  echo -e "\e[33mDocker Compose verified\e[0m"
fi

echo -e "\e[34m=== STEP 6: Restore services folder ===\e[0m"
if [ ! -d "$SERVICES_DIR" ]; then
  mkdir -p "$SERVICES_DIR"
  echo -e "\e[33mCreated directory: service\e[0m"
fi

USB_PATH="/media/$USER_NAME/usb"

if [ -d "$USB_PATH/$BACKUP_DIR" ]; then
  sudo rsync -a --progress "$USB_PATH/$BACKUP_DIR/" "$SERVICES_DIR/"
else
  echo -e "\e[33mBackup services folder not found on USB\e[0m"
  exit 1
fi

echo -e "\e[34m=== STEP 7: Fix ownership ===\e[0m"
sudo chown -R $USER_NAME:$USER_NAME "$SERVICES_DIR"

echo -e "\e[34m=== STEP 8: Start services (if present) ===\e[0m"

for svc in pihole homeassistant portainer plex; do 
  if [ -d "$SERVICES_DIR/$svc" ]; then
    echo -e "\e[33mStarting $svc\e[0m"
    cd "$SERVICES_DIR/$svc"
    docker compose up -d
  fi
done

echo -e "\e[34m=== DONE ===\e[0m"
echo -e "\e[34mLogout and login again if Docker group was just added.\e[0m"
