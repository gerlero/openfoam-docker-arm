# syntax = edrevo/dockerfile-plus

INCLUDE+ openfoam-run_leap.Dockerfile

# run target: builds an 'openfoam-run' image
FROM user AS run

# dev target: builds an 'openfoam-dev' image
FROM run AS dev

RUN zypper -n install -y ${PACKAGE}-devel \
 && zypper -n clean

# default target: builds an 'openfoam-default' image
FROM dev AS default

RUN zypper -n install -y ${PACKAGE}-default \
 && zypper -n clean
