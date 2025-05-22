#!/bin/bash

THISDIR=$(dirname "$(realpath "$0")")
. $THISDIR/build-common.sh

FRAMEWORKNAME=frosty_rust.xcframework
DYLIBNAME=libfrosty_rust.dylib
LIBNAME=libfrosty_rust.a

# Build all targets in native directory
cd ../native/
for TARGET in \
    aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim \
    x86_64-apple-darwin aarch64-apple-darwin
do
    rustup target add $TARGET || exit 1
    cargo build -r --target=$TARGET || exit 1
done

# Create framework in output directory

cd $OUTPUTDIR
mkdir mac-lipo ios-sim-lipo

MAC_LIPO=mac-lipo/$LIBNAME
IOS_SIM_LIPO=ios-sim-lipo/$LIBNAME
TARGETDIR=../native/target

lipo -create -output $IOS_SIM_LIPO \
        $TARGETDIR/aarch64-apple-ios-sim/release/$LIBNAME \
        $TARGETDIR/x86_64-apple-ios/release/$LIBNAME || exit 1
lipo -create -output $MAC_LIPO \
        $TARGETDIR/aarch64-apple-darwin/release/$LIBNAME \
        $TARGETDIR/x86_64-apple-darwin/release/$LIBNAME || exit 1
xcodebuild -create-xcframework \
        -library $IOS_SIM_LIPO \
        -library $MAC_LIPO \
        -library $TARGETDIR/aarch64-apple-ios/release/$LIBNAME \
        -output $FRAMEWORKNAME || exit 1
tar -czvf $FRAMEWORKNAME-$VERSION.zip $FRAMEWORKNAME

# Create universal dylib for use locally
lipo -create -output $LOCALBUILDDIR/$DYLIBNAME \
    $TARGETDIR/aarch64-apple-darwin/release/$DYLIBNAME \
    $TARGETDIR/x86_64-apple-darwin/release/$DYLIBNAME || exit 1

# Cleanup
rm -r ios-sim-lipo mac-lipo $FRAMEWORKNAME
