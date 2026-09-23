# Frosty

Frosty is a Dart library for generating FROST threshold Schnorr Signatures for
secp256k1 and Taproot. There are the classes `DkgPart1`, `DkgPart2` and
`DkgPart3` for conducting Distributed Key Generation. `SignPart1` and
`SignPart2` are used to generate signature shares that can be aggregated with
`SignatureAggregation`.

The library uses the
[frost-secp256k1-tr](https://crates.io/crates/frost-secp256k1-tr) Rust crate
that implements that FROST scheme for Taproot.

Call `await loadFrosty()` before using the API. On Android, iOS, Linux, macOS,
and Windows, the package build hook compiles and bundles the Rust library
automatically through Dart code assets. Rust and rustup must be installed on
the development machine.

Flutter applications depend on this package directly; a separate
`frosty_flutter` plugin is not required. Web builds use the bundled
wasm-bindgen files under `web/pkg`.
