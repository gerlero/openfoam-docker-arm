# OpenFOAM for ARM via Docker

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

For more details on how to use the script and OpenFOAM with Docker in general, you may want to check out the [OpenFOAM Docker page](https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker).

## Docker image

The Docker image used by the script is available as [`gerlero/openfoam2016-default`](https://hub.docker.com/r/gerlero/openfoam2106-default). It is intended to directly replace the [official Docker images](https://hub.docker.com/r/opencfd/) by OpenCFD. Currently, `-dev` and `-run` "slimmer" images are provided as aliases of the `-default` image.

### Building the image

If you want to manually build the image, clone this repo and run:

```sh
docker build --build-arg FOAM_VERSION=2106 --platform linux/arm64 -t gerlero/openfoam2106-default -f openfoam-default.Dockerfile .
```

Note that the build can take a long time, as it will compile OpenFOAM entirely from its source code.

## License

File assets are GPL-3.0+ (as per OpenFOAM itself). Based on the [official _packaging/containers_ repository](https://develop.openfoam.com/packaging/containers).