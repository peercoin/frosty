## Next

- Replace the separate `frosty_flutter` plugin and Cargokit integration with a
  `code_assets` build hook powered by `native_toolchain_rust`.
- Require Dart 3.13 and support the Coinlib `dart-3.13` branch, including its
  current 5.0.0 metadata and planned Coinlib 6 release.
- Consolidate the Dart and Flutter examples under `frosty/example`.
- Remove obsolete native build scripts; retain only the reproducible WASM
  generator.

## 4.0.0

- Update to flutter_rust_bridge 2.11.0 and fix to this version

## 3.0.0

- Add `constructPrivateKey` methods to `AggregateKeyInfo` and
    `ParticipantKeyInfo`.
- Update to flutter_rust_bridge 2.10.0 and fix to this version

## 2.0.0

Provides compatibility with frosty_flutter. The Rust bindings have been updated
and a new native library is required.

## 1.1.0

Use coinlib v4.0.0 and improve build scripts

## 1.0.0

- Initial version.
