# Frosty

Frosty is a Dart library for generating FROST threshold Schnorr Signatures for
secp256k1.

## Installation and Usage

Currently the library has options available to build for Linux and Android.
Library binaries must be built for the native Rust code.

Podman or Docker should be used to build the binaries. This helps to provide a
consistent and reliable build across machines.

### Linux Builds

The `scripts/build-linux.sh` script can be executed. An archive of the Linux
library will be produced in `platform-build` and a copy will be placed in
`frosty/build` so that the tests can be run in the `frosty` directory.

The shared library is expected to exist within the `$PWD/build/` directory or
within the library paths.

### Android Builds

The `scripts/build-android.sh` script can be executed. An archive of the
libraries for the armeabi-v7a and arm64-v8a architectures will be produced in
`platform-build` as `jniLibs.tar.gz`. This can be extracted into the
`android/app/src/main` directory of an Android flutter app.

## Development

Rust and Cargo are required to generate Rust bindings using
[flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge).
The `bash scripts/build-dev.sh` script can be used to generate bindings and it
will build a debug library to `frosty/build` so that tests can be run.

Dart code is found in `frosty` and native Rust code is found in `native`.
