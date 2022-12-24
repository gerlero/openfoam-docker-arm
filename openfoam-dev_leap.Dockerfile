# ---------------------------------*-sh-*------------------------------------
# Copyright (C) 2021-2022 OpenCFD Ltd.
# Copyright (C) 2022 Gabriel S. Gerlero
# SPDX-License-Identifier: (GPL-3.0+)
#
# Add development layer onto the openfoam '-run' (openSUSE) image.
#
# Example
#     docker build -f openfoam-dev_leap.Dockerfile .
#     docker build --build-arg FOAM_VERSION=2212
#         -t gerlero/openfoam2212-dev ...
#
# ---------------------------------------------------------------------------
ARG FOAM_VERSION=2212

FROM gerlero/openfoam-run:${FOAM_VERSION}
ARG FOAM_VERSION
ARG PACKAGE=openfoam${FOAM_VERSION}-devel

RUN zypper install -y ${PACKAGE} \
 && zypper -n clean


# ---------------------------------------------------------------------------
