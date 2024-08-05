import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class UseAfterFree implements Exception {}

class RustObjectWrapper<T extends RustOpaqueInterface> {

  final T _underlying;

  RustObjectWrapper(this._underlying);

  T get underlying {
    if (_underlying.isDisposed) {
      throw UseAfterFree();
    }
    return _underlying;
  }

  /// May be called when the underlying rust object is no longer needed to clear
  /// memory before GC.
  void dispose() => _underlying.dispose();

}

abstract class WritableRustObjectWrapper<T extends RustOpaqueInterface>
extends RustObjectWrapper<T> {

  WritableRustObjectWrapper(super._underlying, [Uint8List? bytes])
    : _bytesCache = bytes;

  Uint8List? _bytesCache;
  /// Obtain the serailised bytes for this object
  Uint8List toBytes() => _bytesCache ??= serializeImpl();

  @override
  void dispose() {
    _bytesCache = null;
    super.dispose();
  }

  /// Subclasses should implement this to obtain the serailised bytes. Use
  /// [toBytes] to obtain a cached version.
  Uint8List serializeImpl();

}
