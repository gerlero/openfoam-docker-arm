# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2022 OpenCFD Ltd.
# Copyright (C) 2022 Gabriel S. Gerlero
# SPDX-License-Identifier: (GPL-3.0+)
#
# Add default (tutorials etc) layer onto the openfoam '-dev' (openSUSE) image.
#
# Example
#     docker build -f openfoam-default_leap.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2212
#         -t gerlero/openfoam2212-default ...
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2212

FROM gerlero/openfoam-dev:${FOAM_VERSION}
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-default

RUN zypper install -y ${PACKAGE} \
 && zypper -n clean


# ---------------------------------------------------------------------------
