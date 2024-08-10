# OpenFOAM for ARM via Docker

| ⚠️ **Deprecated in favor of [OpenFOAM.app](https://github.com/gerlero/openfoam-app) (for macOS users) and [`docker-openfoam`](https://github.com/gerlero/docker-openfoam) (for Docker images)** |
| ---- |

[![Build status](https://img.shields.io/badge/v2406-official%20image-green)](https://hub.docker.com/u/opencfd)
[![Build status](https://img.shields.io/badge/v2312-official%20image-green)](https://hub.docker.com/u/opencfd)
[![Build status](https://img.shields.io/badge/v2306-official%20image-green)](https://hub.docker.com/u/opencfd)
[![Build status](https://img.shields.io/github/actions/workflow/status/gerlero/openfoam-docker-arm/build-push.yml?branch=v2212&label=v2212)](https://github.com/gerlero/openfoam-docker-arm/tree/v2212)
[![Build status](https://img.shields.io/github/actions/workflow/status/gerlero/openfoam-docker-arm/build-push.yml?branch=v2206&label=v2206)](https://github.com/gerlero/openfoam-docker-arm/tree/v2206)
[![Build status](https://img.shields.io/github/actions/workflow/status/gerlero/openfoam-docker-arm/build-push.yml?branch=v2112&label=v2112)](https://github.com/gerlero/openfoam-docker-arm/tree/v2112)
[![Build status](https://img.shields.io/github/actions/workflow/status/gerlero/openfoam-docker-arm/build-push.yml?branch=v2106&label=v2106)](https://github.com/gerlero/openfoam-docker-arm/tree/v2106)
[![Build status](https://img.shields.io/github/actions/workflow/status/gerlero/openfoam-docker-arm/build-push.yml?branch=v2012&label=v2012)](https://github.com/gerlero/openfoam-docker-arm/tree/v2012)
[![homebrew](https://img.shields.io/badge/homebrew-gerlero%2Fopenfoam%2Fopenfoam--docker--arm-informational)](https://github.com/gerlero/homebrew-openfoam)

Precompiled OpenFOAM environments for ARM-based processors via Docker.

**For use on Macs with Apple silicon and other ARM-based computers.**

## Benchmark

On an M1 MacBook Air, running the `incompressible/simpleFoam/pitzDaily` tutorial case took:

* ~80 seconds when using the [official Docker environment](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker) (which runs under emulation as it is not currently compiled for ARM)

* ~6 seconds using this environment compiled for ARM-based processors

## Usage

The [`openfoam-docker-arm`](openfoam-docker-arm) script works just like the official [`openfoam-docker`](https://develop.openfoam.com/packaging/containers/-/blob/main/openfoam-docker) script. Get it in one of these ways:

* Download using the terminal:

    ```sh
    curl -o openfoam-docker-arm https://raw.githubusercontent.com/gerlero/openfoam-docker-arm/main/openfoam-docker-arm
    chmod +x openfoam-docker-arm
    ```

* Download with [Homebrew](https://brew.sh):

    ```sh
    brew install gerlero/openfoam/openfoam-docker-arm
    ```

    **Note:** you can also replace `openfoam-docker-arm` with `openfoam-docker` in the above command to [get the `openfoam-docker` script](https://github.com/gerlero/homebrew-openfoam).

Then, launch an ARM-based OpenFOAM environment at any time using the script. For example, when installed with Homebrew (prepend `./` if downloaded manually into the current directory):

```sh
openfoam-docker-arm -default
```

The `-default` option requests a full environment (including the tutorial suite and dependencies needed for OpenFOAM development). To ask for a specific OpenFOAM version, pass the version number as an option (e.g., `-2212`, `-2206`, `-2112` or `-2106`). For help on how to use the script and OpenFOAM with Docker in general, use the `-help` option and/or check out the [OpenFOAM Docker page](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker).

## Details

ARM-based OpenFOAM environments are packaged in Docker images based on OpenSUSE Leap, using the official ARM binaries as recommended in the [OpenFOAM Docker FAQ](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker#frequently-asked-questions). Note that this means that the base Linux distribution differs from the [official Docker images](https://hub.docker.com/u/opencfd), which use Ubuntu. The ARM-based Docker images are built here using GitHub Actions and uploaded to [Docker Hub](https://hub.docker.com/u/gerlero/). Dockerfiles and supporting files are based on those in the [official _packaging/containers_ repository](https://develop.openfoam.com/packaging/containers).

## Legal notices

### Disclaimer

This offering is not approved or endorsed by OpenCFD Limited, producer and distributor of the OpenFOAM software via www.openfoam.com, and owner of the OPENFOAM®  and OpenCFD® trade marks.

### Trademark acknowledgement

OPENFOAM® is a registered trade mark of OpenCFD Limited, producer and distributor of the OpenFOAM software via www.openfoam.com.
