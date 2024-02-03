# Frosty

**This library is a Work In Progress. It is not ready for production use.**

Frosty is a Dart library for generating FROST threshold Schnorr Signatures for
secp256k1.

## Installation and Usage

Currently the library only has options available to build for Linux and cannot
be used for flutter.

Podman or Docker can be used to build for Linux. Using these helps to provide a
consistent and reliable build across machines.

To build the library `melos build:linux` can be run in the root repository
directory if [Melos](https://melos.invertase.dev/getting-started) is installed.
Otherwise `scripts/build-linux.sh` script can be executed directly with bash.
This will build an archive to `platform-build` and the library will also be
placed into `frosty/build`.

The Dart package will look for the library in the `build` directory of the
working directory, or it will search for the library in the library paths.

## Development

Rust and Cargo are required to generate Rust bindings using
[flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge).
`melos build:dev` or `bash scripts/build-dev.sh` can be used to generate
bindings and it will build a debug library to `frosty/build` so that tests can
be run.

Dart code is found in `frosty` and native Rust code is found in `native`.

