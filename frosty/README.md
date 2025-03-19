# Frosty

Frosty is a Dart library for generating FROST threshold Schnorr Signatures for
secp256k1 and Taproot. There are the classes `DkgPart1`, `DkgPart2` and
`DkgPart3` for conducting Distributed Key Generation. `SignPart1` and
`SignPart2` are used to generate signature shares that can be aggregated with
`SignatureAggregation`.

The library uses the
[frost-secp256k1-tr](https://crates.io/crates/frost-secp256k1-tr) Rust crate
that implements that FROST scheme for Taproot.

It requires a native Rust library to be loaded. A README.md for building this
library can be found in the root of the repository.
