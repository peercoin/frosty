# Frosty for Flutter

This plugin allows `frosty` to be used on flutter apps without needing to
prebuild the libraries. Linux, Android, macOS, iOS, and web platforms are
supported. Windows may also work but hasn't been tested.

The `FrostyLoader` widget is also provided that ensures that the library has
loaded before use.

For web, the wasm-bindgen outputs are bundled in `web/pkg` and loaded by
`loadFrosty`/`FrostyLoader` from `assets/packages/frosty_flutter/web/pkg`.
