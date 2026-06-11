#!/bin/bash

. $THISDIR/build-common.sh

# Ensure build() is exported
set -a

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

# The function that builds for linux or wasm
build () {
    echo "Building for $1"
    mkdir -p $2
    # Run container leaving build result in proper place
    $PROGCMD run --rm \
        --volume $OUTPUTDIR/$2:/output:Z \
        $TAG bash -c \
        "cargo build -r --target $1 && \
        cp /build/target/$1/release/$LIBNAME /output/$LIBNAME && \
        if [ \"$2\" = \"wasm\" ]; then \
            mkdir -p /output/pkg && \
            wasm-bindgen --target no-modules \
              --out-name $WASM_BINDGEN_OUTNAME \
              --out-dir /output/pkg \
              /build/target/$1/release/$LIBNAME; \
        fi" \
        || exit 1
    if [ "$2" = "wasm" ]; then
      echo "Copying wasm-bindgen outputs to $WEB_OUTDIR"
      mkdir -p "$WEB_OUTDIR"
      cp "$2/pkg/$WASM_BINDGEN_OUTNAME.js" "$WEB_OUTDIR"
      cp "$2/pkg/${WASM_BINDGEN_OUTNAME}_bg.wasm" "$WEB_OUTDIR"
    else
      echo "Copying to frosty/build for local use"
      cp $2/$LIBNAME $LOCALBUILDDIR/$LIBNAME
    fi
    echo "Archiving $1"
    tar -czvf frosty-$VERSION-$2.tar.gz -C $2 .
    rm -r $2
}
