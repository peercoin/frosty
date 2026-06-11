#!/bin/bash

THISDIR=$(dirname "$(realpath "$0")")
. $THISDIR/build-common-container.sh

LIBNAME=frosty_rust.wasm
WASM_BINDGEN_OUTNAME=frosty_rust
WEB_OUTDIR=$THISDIR/../frosty_flutter/web/pkg

# Build container image with the build context being the parent directory
TAG=frosty_rust_wasm_build
$PROGCMD build -f $THISDIR/build_wasm.Dockerfile -t $TAG $THISDIR/.. || exit 1

# Build for wasm32-unknown-unknown
build wasm32-unknown-unknown wasm
