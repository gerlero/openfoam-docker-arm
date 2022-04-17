# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021 OpenCFD Ltd.
# Copyright (C) 2022 Gabriel S. Gerlero
# SPDX-License-Identifier: (GPL-3.0+)
#
# Add default (tutorials etc) layer onto the openfoam '-dev' (openSUSE) image.
#
# Example
#     docker build -f openfoam-default_leap.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2112
#         -t gerlero/openfoam2112-default ...
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2112

FROM gerlero/openfoam-dev:${FOAM_VERSION}
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-default

RUN zypper install -y ${PACKAGE} \
 && zypper -n clean


# ---------------------------------------------------------------------------
