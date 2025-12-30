#!/bin/bash

THISDIR=$(dirname "$(realpath "$0")")
. $THISDIR/build-common-container.sh

LIBNAME=frosty_rust.wasm
WASM_BINDGEN_OUTNAME=frosty_rust
WEB_OUTDIRS=(
    "$THISDIR/../frosty_flutter/example/web/pkg"
    "$THISDIR/../frosty_flutter/web/pkg"
)

# Build container image with the build context being the parent directory
TAG=frosty_rust_wasm_build
$PROGCMD build -f $THISDIR/build_wasm.Dockerfile -t $TAG $THISDIR/.. || exit 1

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
    echo "Copying to frosty/build for local use"
    cp $2/$LIBNAME $LOCALBUILDDIR/$LIBNAME
    if [ "$2" = "wasm" ]; then
        for web_outdir in "${WEB_OUTDIRS[@]}"; do
            echo "Copying wasm-bindgen outputs to $web_outdir"
            mkdir -p "$web_outdir"
            cp "$2/pkg/$WASM_BINDGEN_OUTNAME.js" "$web_outdir/"
            cp "$2/pkg/${WASM_BINDGEN_OUTNAME}_bg.wasm" "$web_outdir/"
        done
    fi
    echo "Archiving $1"
    tar -czvf frosty-$VERSION-$2.tar.gz -C $2 . 
    rm -r $2
}

# Build for wasm32-unknown-unknown
build wasm32-unknown-unknown wasm
