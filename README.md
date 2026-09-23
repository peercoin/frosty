# Frosty

Frosty is a Dart and Flutter library for generating FROST threshold Schnorr
signatures for secp256k1 and Taproot.

The published package lives in `frosty/`. Its Rust crate is in `frosty/rust`
and is compiled and bundled automatically on Android, iOS, Linux, macOS, and
Windows by the Dart build hook using `code_assets` and
`native_toolchain_rust`. Consumers therefore depend on `frosty` directly;
there is no separate Flutter plugin package.

Rust and rustup must be available on the development machine. The toolchain
and supported targets are pinned in `frosty/rust/rust-toolchain.toml`.

## Development

From the package directory:

```sh
cd frosty
dart pub get
dart test
dart analyze
```

The repository workspace overrides Coinlib with its `dart-3.13` branch so the
upcoming native-assets release is continuously exercised before publication.
The published Frosty package accepts Coinlib 5 and 6.

The build hook compiles the native library before tests or application builds.
The Flutter app under `frosty/example/` exercises the same package and hook on
all supported Flutter platforms. The Dart CLI examples live in that directory
as well.

Web continues to use the checked-in wasm-bindgen output in `frosty/web/pkg`.
Run `scripts/build-wasm.sh` to refresh those files.

To regenerate the bridge after changing the Rust API, run
`flutter_rust_bridge_codegen generate` from `frosty/`. The WASM generator is
the only remaining script because Dart code assets handle every native target.
