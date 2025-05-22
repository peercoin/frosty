#!/bin/bash

. $THISDIR/build-common.sh

# Prefer podman
if type podman > /dev/null; then
    PROGCMD=podman
    echo "Will attempt to use podman"
else
    PROGCMD=docker
    echo "Podman not available, attempting to use docker"
fi

# Build common build image
$PROGCMD build -f $THISDIR/build_common.Dockerfile -t frosty_build_common $THISDIR/.. \
    || exit 1
