import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;

/// Contains the participants public shares for verification of signature shares
/// by the coordinator.
class PublicKeyShares extends RustObjectWrapper<rust.FrostKeysPublicKeyPackage> {

  PublicKeyShares.fromUnderlying(super._underlying);

}
