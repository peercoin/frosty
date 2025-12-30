import 'package:coinlib/coinlib.dart';
import 'rust_api_io.dart'
    if (dart.library.js_interop) 'rust_api_web.dart';
export 'generated/api/main.dart';

bool _loaded = false;

/// Loads the underlying Rust library.
Future<void> loadFrosty({String? webRoot}) async {
  if (_loaded) return;
  _loaded = true;
  await loadFrostyImpl(webRoot: webRoot);
  await loadCoinlib();
}
