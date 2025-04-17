#!/bin/bash

OUTPUTDIR=$THISDIR/../platform-build
VERSION=1.1.0

# Prefer podman
if type podman > /dev/null; then
    PROGCMD=podman
    echo "Will attempt to use podman"
else
    PROGCMD=docker
    echo "Podman not available, attempting to use docker"
fi

# Create build and output directory
mkdir -p $OUTPUTDIR

# Build common build image
$PROGCMD build -f $THISDIR/build_common.Dockerfile -t frosty_build_common $THISDIR/.. \
    || exit 1

# Build into output directory
cd $OUTPUTDIR
