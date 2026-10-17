# Frosty

Frosty is a Dart and Flutter library for generating FROST threshold Schnorr
signatures for secp256k1 and Taproot.

The published package lives at the repository root. Its Rust crate is in `rust/`
and is compiled and bundled automatically on Android, iOS, Linux, macOS, and
Windows by the Dart build hook using `code_assets` and
`native_toolchain_rust`. Consumers therefore depend on `frosty` directly;
there is no separate Flutter plugin package.

Rust and rustup must be available on the development machine. The toolchain
and supported targets are pinned in `rust/rust-toolchain.toml`.

The library uses the
[frost-secp256k1-tr](https://crates.io/crates/frost-secp256k1-tr) Rust crate.
Call `await loadFrosty()` before using the API. Use `DkgPart1`, `DkgPart2`, and
`DkgPart3` for distributed key generation, then `SignPart1` and `SignPart2` to
generate signature shares and `SignatureAggregation` to combine them.

## Development

From the repository root:

```sh
dart pub get
dart test
dart analyze
```

The package uses coinlib from pub.dev. Both native libraries are built and
bundled through Dart code assets.

The build hook compiles the native library before tests or application builds.
The Flutter app under `example/` exercises the same package and hook on
all supported Flutter platforms. The Dart CLI examples live in that directory
as well.

Web continues to use the checked-in wasm-bindgen output in `web/pkg`.
Run `scripts/build-wasm.sh` to refresh those files.

To regenerate the bridge after changing the Rust API, run
`flutter_rust_bridge_codegen generate` from the repository root. The WASM
generator is the only remaining script because Dart code assets handle every
native target.
