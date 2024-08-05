#!/bin/bash

THISDIR=$(dirname "$(realpath "$0")")
. $THISDIR/build-common.sh

# Build container image with the build context being the parent directory
TAG=frosty_rust_android_build
$PROGCMD build -f $THISDIR/build_android.Dockerfile -t $TAG $THISDIR/.. || exit 1

echo "Building for Android"
mkdir jniLibs

# Run container leaving build result in proper place
$PROGCMD run --rm \
    --volume $OUTPUTDIR/jniLibs:/output:Z \
    $TAG bash -c \
    "cargo ndk -o /build/jniLibs --manifest-path ./Cargo.toml \
    -t armeabi-v7a -t arm64-v8a \
    build --release \
    && cp -r /build/jniLibs/* /output/" \
    || exit 1

echo "Archiving Android build to $OUTPUTDIR/jniLibs.tar.gz"
tar -czvf jniLibs.tar.gz -C jniLibs .
rm -r jniLibs
