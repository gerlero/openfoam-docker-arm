# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# Copyright (C) 2021 Gabriel S. Gerlero
# SPDX-License-Identifier: (GPL-3.0+)
#
# Example
#     docker build -f openfoam-default.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2112 ...
#
# ---------------------------------------------------------------------------

ARG OS_VER=latest

FROM ubuntu:${OS_VER} AS distro

FROM distro AS runtime
ARG FOAM_VERSION=2106
ARG PACKAGE=openfoam${FOAM_VERSION}
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /openfoam
SHELL ["/bin/bash", "-c"]

RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    apt-utils vim-tiny nano-tiny wget ca-certificates rsync \
    sudo passwd libnss-wrapper \
    build-essential autoconf autotools-dev cmake gawk gnuplot \
    flex libfl-dev libreadline-dev zlib1g-dev openmpi-bin libopenmpi-dev mpi-default-bin mpi-default-dev \
    libgmp-dev libmpfr-dev libmpc-dev \
 && rm -rf /var/lib/apt/lists/* \
 && wget -O - https://sourceforge.net/projects/openfoam/files/v${FOAM_VERSION}/OpenFOAM-v${FOAM_VERSION}.tgz | tar xzf - \
 && mv OpenFOAM-v${FOAM_VERSION} openfoam${FOAM_VERSION} \
 && cd openfoam${FOAM_VERSION} \
 && wget -O - https://sourceforge.net/projects/openfoam/files/v${FOAM_VERSION}/ThirdParty-v${FOAM_VERSION}.tgz | tar xzf - \
 && mv ThirdParty-v${FOAM_VERSION} ThirdParty \
 && source etc/bashrc \
 && ThirdParty/Allwmake -j -s -q \
 && ./Allwmake -j -s -q \
 && rm -rf build \
 && rm -rf ThirdParty/build

# ---------------
# User management
# - nss-wrapper
# - openfoam sandbox directory

FROM runtime AS user
COPY openfoam-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/post-install.sh -fix-perms

ENTRYPOINT [ "/openfoam/run" ]

# ---------------------------------------------------------------------------
