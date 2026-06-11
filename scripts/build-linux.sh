#!/bin/bash

THISDIR=$(dirname "$(realpath "$0")")
. $THISDIR/build-common-container.sh

LIBNAME=libfrosty_rust.so

# Build container image with the build context being the parent directory
TAG=frosty_rust_linux_build
$PROGCMD build -f $THISDIR/build_linux.Dockerfile -t $TAG $THISDIR/.. || exit 1

# Build for x64 only for now
build x86_64-unknown-linux-gnu linux-x64
