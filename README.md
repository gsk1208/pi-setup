# pi-setup
setup scripts after fresh flash

## Overview

- `setup-services.sh`: Script to automate the setup and deployment of the services using Docker Compose.
- `services/`: Directory containing configuration files and Docker Compose definitions for each service.

## Services

- **Home Assistant**: Open-source home automation platform for controlling smart home devices and creating automations.
- **OpenMediaVault**: Network-attached storage (NAS) solution based on Debian, providing file sharing and storage management.
- **Pi-hole**: Network-wide ad blocker that acts as a DNS sinkhole to block ads and trackers.
- **Portainer**: Lightweight Docker management tool for managing containers, images, and networks through a web UI.
