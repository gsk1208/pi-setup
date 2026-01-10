# pi-setup

A small collection of Docker Compose service definitions and helper scripts intended to provision common home-server services (Home Assistant, Pi-hole, OpenMediaVault, Portainer, Plex, Twingate) for a Raspberry Pi or similar single-board Linux host.

## Repo layout

- `setup-services.sh` - orchestration helper to prepare and bring up services.
- `services/` - per-service folders containing `docker-compose.yml` and service config directories.
  - `homeassistant/` - Home Assistant compose + `config/` (automations, scripts, secrets, blueprints, logs)
  - `pihole/` - Pi-hole compose, Dockerfile and `etc-pihole/` config and backups
  - `openmediavault/` - OMV compose + `config/`
  - `portainer/` - Portainer compose + `data/` for certs and configuration
  - `plex/`, `twingate/` - service folders

## Goals

- Provide reproducible Docker Compose definitions for common home-server services.
- Keep config directories close to the compose files so backups and edits are easy.
- Offer a small setup helper (`setup-services.sh`) to bootstrap basic setup.

## Prerequisites

- A Linux host (Raspberry Pi OS, Debian, Ubuntu) or WSL with Docker & Docker Compose v2.
- Docker installed and the user able to run Docker commands (or via `sudo`).
- Sufficient disk space and a static IP or DHCP reservation for services like Pi-hole and Home Assistant.

Install Docker and Docker Compose (example for Debian/Raspbian):

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER
```

Then install `docker-compose` plugin if needed (Docker Compose V2 is usually included as `docker compose`).

## Quick start

1. Review and customize per-service configuration under `services/<service>/config/`.
2. (Optional) Make any required `.env` files or secrets changes in each service folder.
3. Run the setup helper to prepare the environment:

```bash
./setup-services.sh
```

4. Or start services individually from their folders:

```bash
cd services/pihole
docker compose up -d

cd ../homeassistant
docker compose up -d
```

## Per-service notes

- Home Assistant: configs live in `services/homeassistant/config/`. Preserve `secrets.yaml` and `configuration.yaml` when upgrading.
- Pi-hole: `services/pihole/etc-pihole/` contains `adlists.list`, `pihole.toml` backups and gravity backups. Review DNS/network settings before enabling.
- Portainer: data is persisted under `services/portainer/data/` (certs, configuration).
- OpenMediaVault & Plex: treat their `config/` folders as single-source-of-truth for host-specific settings.

## Configuration & backups

- Keep copies of `secrets.yaml`, Pi-hole `pihole.toml`, and Compose overrides outside the container data directory.
- Use standard tools (rsync, borg, or simple tar gzip) to back up `services/*/config` regularly.

## Security

- Do not expose admin ports to the public internet without reverse proxy + auth (e.g., Traefik, Nginx, OAuth proxy).
- Rotate secrets and API keys; store sensitive values in `secrets.yaml` or environment-managed secret stores.

## Troubleshooting

- Check container logs:

```bash
docker compose logs -f
```

- Inspect containers and volumes with `docker ps`, `docker inspect`, `docker volume ls`.

## Contributing

1. Open an issue describing the change.
2. Fork the repo, make changes, and submit a PR.

## License

Repository does not include an explicit license. Add one if you intend to allow reuse

---

If you'd like, I can:

- add a simple `.env.example` for common variables;
- add per-service README notes linking to important config files;
- or run a basic lint/validation against each `docker-compose.yml`.

Files to review: [setup-services.sh](setup-services.sh) and the service compose files under `services/`.
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
