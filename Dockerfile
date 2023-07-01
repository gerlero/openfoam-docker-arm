# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2022 OpenCFD Ltd.
# Copyright (C) 2023 Gabriel Gerlero
# SPDX-License-Identifier: (GPL-3.0+)
#
# Create openfoam '-run' image using Ubuntu.
#
# Example
#     docker build -f openfoam-run.Dockerfile .
#     docker build --build-arg OS_VER=impish --build-arg FOAM_VERSION=2212
#         -t opencfd/openfoam-run:2212 ...
#
# Note
#     Uses wget for fewer dependencies than curl
#
# ---------------------------------------------------------------------------
ARG OS_VER=latest

FROM ubuntu:${OS_VER} AS distro

# Version-independent base layer
FROM distro AS base0
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    apt-utils vim-tiny nano-tiny wget ca-certificates rsync \
    sudo passwd libnss-wrapper \
 && rm -rf /var/lib/apt/lists/*

# Version-specific runtime layer
FROM base0 AS runtime
ARG FOAM_VERSION=2212
ARG PACKAGE=openfoam${FOAM_VERSION}
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && wget -q -O - https://dl.openfoam.com/add-debian-repo.sh | bash \
 && apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*

# ---------------
# User management
# - nss-wrapper
# - openfoam sandbox directory

FROM runtime AS user
COPY openfoam-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/post-install.sh -fix-perms

ENTRYPOINT [ "/openfoam/run" ]

# ---------------------------------------------------------------------------

FROM user AS run

# ---------------------------------------------------------------------------

FROM run AS dev
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-dev
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------

FROM dev AS default
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-default
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get -y install --no-install-recommends ${PACKAGE} \
 && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
