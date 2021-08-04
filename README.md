# Dockerised CUPS service

![build](https://github.com/fpiesche/docker-cups/actions/workflows/main.yml/badge.svg)

A Docker container running CUPS, useful for e.g. turning a Raspberry Pi into a print server while remaining interchangeable and easy to reproduce.

# Quick reference

-   **Image Repositories**:
    - Docker Hub: [`florianpiesche/cups`](https://hub.docker.com/r/florianpiesche/cups)  
    - GitHub Packages: [`ghcr.io/fpiesche/cups`](https://ghcr.io/fpiesche/cups)  

-   **Maintained by**:  
	[Florian Piesche](https://github.com/fpiesche)

-	**Where to file issues**:  
    [https://github.com/fpiesche/docker-cups/issues](https://github.com/fpiesche/docker-cups/issues)

-   **Base image**:
    [debian:buster-slim](https://hub.docker.com/_/debian/)

-   **Dockerfile**:
    [https://github.com/fpiesche/docker-cups/blob/main/Dockerfile](https://github.com/fpiesche/docker-cups/blob/main/Dockerfile)

-	**Supported architectures**:
    Each image is a multi-arch manifest for the following architectures:
    `amd64`, `arm64`, `armv7`, `armv6`

-	**Source of this description**: [Github README](https://github.com/fpiesche/docker-cups/tree/master/README.md) ([history](https://github.com/fpiesche/docker-cups/commits/master/README.md))

# Supported tags

-   `latest` is based on the most recent released Debian base image and its respective system packages.

# How to use this image


You will need to run this container in "privileged" mode to be able to access printers on the host machine, or mount the relevant devices into the container.

On startup, the container will automatically create an admin user for cups, called `admin`. The password for this will be randomly generated unless a specific password is given via the `ADMIN_PASSWORD` environment variable.

Custom shell scripts required for setup (e.g. to install custom printer drivers) can be mounted in `/setup_scripts/custom/`. A script to install the HP printer drivers via `hplip` is included and can be enabled by setting the `INSTALL_HP_PLUGIN` environment variable.

```console
$ docker run -d \
  --privileged \
  -p 6310:631 \
  -e ADMIN_PASSWORD="cups-admin" \
  -e INSTALL_HP_PLUGIN="true" \
  florianpiesche/cups
```

Once startup completes, you can access the CUPS configuration interface at `http://localhost:6310/` on your host computer.

## Persistent data

The CUPS configuration data is stored in an [unnamed docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume) mounted in the container at `/etc/cups`. The docker daemon will store that data within the docker directory `/var/lib/docker/volumes/...`, so that the CUPS configuration is saved even if the container crashes, is stopped or deleted.

A named Docker volume or a mounted host directory can be used for upgrades and backups. You can add this by using the `-v` parameter when running Docker:

```console
$ docker run -d \
  --privileged \
  -p 6310:631 \
  -v cupsconfig:/etc/cups \
  -e ADMIN_PASSWORD="cups-admin" \
  -e INSTALL_HP_PLUGIN="true" \
  florianpiesche/cups
```

## Using docker-compose

The easiest way to get a reproducible setup you can start, stop and resume at will is using a `docker-compose` file. There are too many different possibilities to setup your system, so here are only some examples of what you have to look for.

To use a compose file, create a file called `docker-compose.yaml` in a new, empty directory on your host computer and paste in this data:

```yaml
version: '2'

volumes:
  cupsconfig:

services:
  cups:
    image: florianpiesche/cups
    privileged: true
    restart: always
    volumes:
      - cupsconfig:/etc/cups
    ports:
      - 6310:631
```

Then run `docker-compose up -d` in the directory holding the compose file, and you will be able to access the CUPS configuration interface at http://localhost:6310/ from your host system. You can stop the CUPS server at any point using `docker-compose down`, and resume it again with your stored configuration by re-running `docker-compose up -d`.
