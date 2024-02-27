import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;

/// A share of a FROST key, allowing a participant to produce signature shares.
/// This must be kept private by the participant that owns it.
class PrivateKeyShare extends RustObjectWrapper<rust.FrostKeysKeyPackage> {

  PrivateKeyShare.fromUnderlying(super._underlying);

}
