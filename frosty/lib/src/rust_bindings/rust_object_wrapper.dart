import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

class UseAfterFree implements Exception {}

class RustObjectWrapper<T extends FrbOpaque> {

  final T _underlying;

  RustObjectWrapper(this._underlying);

  T get underlying {
    if (_underlying.isStale()) {
      throw UseAfterFree();
    }
    return _underlying;
  }

  /// May be called when the underlying rust object is no longer needed to clear
  /// memory before GC.
  void dispose() => _underlying.dispose();

}

