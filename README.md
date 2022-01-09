# OpenFOAM for ARM via Docker

[![Build status](https://img.shields.io/github/workflow/status/gerlero/openfoam-docker-arm/build-push/v2112?label=v2112)](https://github.com/gerlero/openfoam-docker-arm/tree/v2112) 
[![Docker Pulls](https://img.shields.io/docker/pulls/gerlero/openfoam2112-run?label=run%20pulls)](https://hub.docker.com/r/gerlero/openfoam2112-run)
[![Docker Pulls](https://img.shields.io/docker/pulls/gerlero/openfoam2112-dev?label=dev%20pulls)](https://hub.docker.com/r/gerlero/openfoam2112-dev)
[![Docker Pulls](https://img.shields.io/docker/pulls/gerlero/openfoam2112-default?label=default%20pulls)](https://hub.docker.com/r/gerlero/openfoam2112-default)

[![Build status](https://img.shields.io/github/workflow/status/gerlero/openfoam-docker-arm/build-push/v2106?label=v2106)](https://github.com/gerlero/openfoam-docker-arm/tree/v2106) 
[![Docker Pulls](https://img.shields.io/docker/pulls/gerlero/openfoam2106-run?label=run%20pulls)](https://hub.docker.com/r/gerlero/openfoam2106-run)
[![Docker Pulls](https://img.shields.io/docker/pulls/gerlero/openfoam2106-dev?label=dev%20pulls)](https://hub.docker.com/r/gerlero/openfoam2106-dev)
[![Docker Pulls](https://img.shields.io/docker/pulls/gerlero/openfoam2106-default?label=default%20pulls)](https://hub.docker.com/r/gerlero/openfoam2106-default)


Precompiled OpenFOAM environments for ARM-based processors via Docker.

**For use on Macs with Apple silicon and other ARM-based computers.**

## Benchmark

On an M1 MacBook Air, running the `incompressible/simpleFoam/pitzDaily` tutorial case took:

* ~80 seconds when using the [official Docker environment](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker) (which runs under emulation as it is not currently compiled for ARM)

* ~6 seconds using this environment compiled for ARM-based processors

## Usage

The [`openfoam-docker-arm`](openfoam-docker-arm) script works just like the official [`openfoam-docker`](https://develop.openfoam.com/packaging/containers/-/blob/main/openfoam-docker) script.

Run these commands in the terminal to download the script and make it executable:

```sh
curl -o openfoam-docker-arm https://raw.githubusercontent.com/gerlero/openfoam-docker-arm/main/openfoam-docker-arm
chmod +x openfoam-docker-arm
```

Then, launch an ARM-based OpenFOAM environment at any time using the script. For example:

```sh
./openfoam-docker-arm -default
```

The `-default` option requests a full environment (including the tutorial suite and dependencies needed for OpenFOAM development). To ask for a specific OpenFOAM version, pass the version number as an option (e.g., `-2112` or `-2106`). For help on how to use the script and OpenFOAM with Docker in general, use the `-help` option and/or check out the [OpenFOAM Docker page](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker).

## Details

ARM-based OpenFOAM environments are packaged in Docker images based on OpenSUSE Leap, using the official ARM binaries as recommended in the [OpenFOAM Docker FAQ](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker#frequently-asked-questions). Note that this means that the base Linux distribution differs from the [official Docker images](https://hub.docker.com/u/opencfd), which use Ubuntu. The ARM-based Docker images are built here using GitHub Actions and uploaded to [Docker Hub](https://hub.docker.com/u/gerlero/).

A previous image of OpenFOAM v2106 contained OpenFOAM compiled from source on Ubuntu, before the switch to OpenSUSE. This (now deprecated) image is still pullable as `gerlero/openfoam2106-default:ubuntu`.

## License

File assets are GPL-3.0+ (as per OpenFOAM itself). Based on the [official _packaging/containers_ repository](https://develop.openfoam.com/packaging/containers).
