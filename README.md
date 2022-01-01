# OpenFOAM for ARM via Docker

[![CI](https://github.com/gerlero/openfoam-docker-arm/actions/workflows/ci.yml/badge.svg)](https://github.com/gerlero/openfoam-docker-arm/actions/workflows/ci.yml)

Precompiled OpenFOAM environment for ARM-based processors via Docker.

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

The `-default` option requests a full environment (including the tutorial suite and dependencies needed for OpenFOAM development). To ask for a specific OpenFOAM version, pass the version number as an option (as of now, `-2112` or `-2106` will work). For help on how to use the script and OpenFOAM with Docker in general, use the `-help` option and/or check out the [OpenFOAM Docker page](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker).

## Details

### OpenFOAM v2112

ARM-based OpenFOAM v2112 environments are packaged in Docker images based on OpenSUSE Leap, using the official ARM binaries as recommended in the [OpenFOAM Docker FAQ](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker#frequently-asked-questions). Note that the base distribution differs from the [official Docker images](`https://hub.docker.com/u/opencfd`), which use Ubuntu. The ARM-based Docker images are built here using GitHub Actions and provided as [`gerlero/openfoam2112-run`](https://hub.docker.com/r/gerlero/openfoam2112-run), [`gerlero/openfoam2112-dev`](https://hub.docker.com/r/gerlero/openfoam2112-dev) and [`gerlero/openfoam2112-default`](https://hub.docker.com/r/gerlero/openfoam2112-default).

### OpenFOAM v2106

The ARM-based OpenFOAM v2106 Docker image is available as [`gerlero/openfoam2016-default`](https://hub.docker.com/r/gerlero/openfoam2106-default). The current version of this image offers OpenFOAM compiled from source on Ubuntu, with the `-dev` and `-run` "slimmer" images provided as simple aliases of the `-default` image.

## License

File assets are GPL-3.0+ (as per OpenFOAM itself). Based on the [official _packaging/containers_ repository](https://develop.openfoam.com/packaging/containers).