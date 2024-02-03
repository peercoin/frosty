#!/bin/bash

THISDIR=$(dirname "$(realpath "$0")")
NATIVEDIR=$THISDIR/../native
OUTPUTDIR=$THISDIR/../frosty/build

# Run Cargo build
cd $NATIVEDIR
cargo build || exit 1

# Copy debug library to local location for frosty to use
cd $THISDIR/../target
mkdir -p $OUTPUTDIR
cp debug/libfrosty_rust.so "$OUTPUTDIR/libfrosty_rust.so"

echo "Rust library built to frost/build and bindings generated"
