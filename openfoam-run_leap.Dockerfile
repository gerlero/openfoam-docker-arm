# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2022 OpenCFD Ltd.
# SPDX-License-Identifier: (GPL-3.0+)
#
# Create openfoam '-run' image for openSUSE using science repo.
#
# Example
#     docker build -f openfoam-run_leap.Dockerfile .
#     docker build --build-arg OS_VER=15.4 --build-arg FOAM_VERSION=2212 ...
#
# ---------------------------------------------------------------------------
ARG OS_VER=15.4

FROM opensuse/leap:${OS_VER} AS distro

FROM distro AS runtime
ARG FOAM_VERSION=2212
ARG PACKAGE=openfoam${FOAM_VERSION}

RUN zypper -n install -y \
    nano wget rsync sudo nss_wrapper \
 && wget -q -O - https://dl.openfoam.com/add-science-repo.sh | bash \
 && zypper -n --gpg-auto-import-keys refresh science \
 && zypper -n install -y ${PACKAGE} \
 && zypper -n clean

# ---------------
# User management
# - nss-wrapper
# - openfoam sandbox directory

FROM runtime AS user
COPY openfoam-files.rc/ /openfoam/
RUN  /bin/sh /openfoam/assets/post-install.sh -fix-perms

ENTRYPOINT [ "/openfoam/run" ]

# ---------------------------------------------------------------------------
