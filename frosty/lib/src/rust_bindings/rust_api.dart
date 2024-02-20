import 'rust_api_io.dart';
export 'rust_api_io.dart';

bool _loaded = false;

/// Loads the underlying Rust library.
Future<void> loadFrosty() async {
  if (_loaded) return;
  await loadFrostyImpl();
  _loaded = true;
}
