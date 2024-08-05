#!/bin/bash

THISDIR=$(dirname "$(realpath "$0")")
. $THISDIR/build-common.sh

LOCALBUILDDIR=$THISDIR/../frosty/build
LIBNAME=libfrosty_rust.so

# Build container image with the build context being the parent directory
TAG=frosty_rust_linux_build
$PROGCMD build -f $THISDIR/build_linux.Dockerfile -t $TAG $THISDIR/.. || exit 1

build () {
    echo "Building for $1"
    mkdir $2
    # Run container leaving build result in proper place
    $PROGCMD run --rm \
        --volume $OUTPUTDIR/$2:/output:Z \
        $TAG bash -c \
        "cargo build -r --target $1 && cp /build/target/$1/release/$LIBNAME /output/$LIBNAME" \
        || exit 1
    echo "Copying to frosty/build for local use"
    cp $2/$LIBNAME $LOCALBUILDDIR/$LIBNAME
    echo "Archiving $1"
    tar -czvf $2.tar.gz -C $2 .
    rm -r $2
}

# Build for x64 only for now
build x86_64-unknown-linux-gnu linux-x64
