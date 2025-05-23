# Frosty

Frosty is a Dart library for generating FROST threshold Schnorr Signatures for
secp256k1.

The Dart package is found under `frosty` and a flutter package is found under
`frosty_flutter` which includes a flutter build of the underlying Rust library.
The native Rust code is found under `frosty_flutter/rust`. Scripts for
building the native libraries for Linux and Android are found in `scripts`,
however `frosty_flutter` provides automatic builds for Linux, Android, macOS and
iOS.

Please see below for build instructions.

## Building and Installation

If you are using Flutter, the `frosty_flutter` package contains support for
automatic builds for different platforms. It requires Rust but otherwise should
not require anything else.

For pure Dart use, it is possible to build a Linux library. Library binaries
must be built for the native Rust code.

Podman or Docker can be used to build the binaries. This helps to provide a
consistent and reliable build across machines.

### Linux Builds

The `scripts/build-linux.sh` script can be executed. An archive of the Linux
library will be produced in `platform-build` and a copy will be placed in
`frosty/build` so that the tests can be run in the `frosty` directory.

During runtime, the shared library is expected to exist within a `$PWD/build/`
directory or within the library paths.

### Android Builds

If you do not wish to use the automatic Android build with `frosty_flutter`, the
`scripts/build-android.sh` script can be executed. An archive of the libraries
for the armeabi-v7a and arm64-v8a architectures will be produced in
`platform-build` as `jniLibs.tar.gz`. This can be extracted into the
`android/app/src/main` directory of an Android flutter app.

### Apple Builds

The `scripts/build-apple.sh` script will produce a universal framework for macOS
and iOS into `platform-build` and a dylib will be created in the `frosty/build`
directory for local testing. This script does not use Podman or Docker and
requires the host machine to have Rust.

## Development

Tests require the Linux Rust library in the `$PWD/build` directory.

If the Rust bindings need to be regenerated, `flutter_rust_bridge_codegen
generate` should be run in the `frosty_flutter` directory.
