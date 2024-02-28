import 'dart:typed_data';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/rust_bindings/invalid_object.dart';
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;

/// Thrown when bytes are not a valid private share
class InvalidPrivateKeyShare extends MessageException {
  InvalidPrivateKeyShare(super.message);
}

/// A share of a FROST key, allowing a participant to produce signature shares.
/// This must be kept private by the participant that owns it.
class PrivateKeyShare extends WritableRustObjectWrapper<rust.FrostKeysKeyPackage> {

  PrivateKeyShare.fromUnderlying(super._underlying);

  /// Reads the private key share and throws [InvalidPrivateKeyShare] if
  /// invalid.
  PrivateKeyShare.fromBytes(Uint8List data) : super(
    handleGetObject(
      () => rust.rustApi.privateKeyShareFromBytes(bytes: data),
      (e) => InvalidPrivateKeyShare(e),
    ),
    data,
  );

  /// Serialises the private key share into bytes which must be kept
  /// confidential and only known by the participant.
  @override
  Uint8List serializeImpl()
    => rust.rustApi.privateKeyShareToBytes(share: underlying);

}
