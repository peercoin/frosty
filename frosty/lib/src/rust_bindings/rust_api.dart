import 'package:coinlib/coinlib.dart';
import 'rust_api_io.dart';
export 'rust_api_io.dart';

bool _loaded = false;

/// Loads the underlying Rust library.
Future<void> loadFrosty() async {
  if (_loaded) return;
  _loaded = true;
  await loadFrostyImpl();
  await loadCoinlib();
}
