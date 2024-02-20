import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';

/// Thrown when bytes are not a valid shared secret
class InvalidSharedSecret implements Exception {
  final String error;
  InvalidSharedSecret(this.error);
  @override
  String toString() => "InvalidSharedSecret: $error";
}

rust.DkgRound2Package _handleGetSecret(
  rust.DkgRound2Package Function() f,
) {
  try {
    return f();
  } on FrbAnyhowException catch(e) {
    throw InvalidSharedSecret(e.anyhow);
  }
}

/// A secret that is to be shared to another participant or a secret that was
/// shared from another participant.
///
/// These must be encrypted and authenticated so that only the recipient has the
/// secret and they know whom it was sent from.
class DkgSharedSecret extends RustObjectWrapper<rust.DkgRound2Package> {

  DkgSharedSecret.fromUnderlying(super._underlying);

  /// Reads the serialised secret from a participant and throws
  /// [InvalidSharedSecret] if invalid.
  DkgSharedSecret.fromBytes(Uint8List data) : super(
    _handleGetSecret(
      () => rust.rustApi.sharedSecretFromBytes(bytes: data),
    ),
  );

  /// Obtains serialised data for the secret that should only be shared to the
  /// recipient participant. Shared secrets must be encrypted and authenticated
  /// and must only be sent to the required recipient.
  Uint8List toBytes() => rust.rustApi.sharedSecretToBytes(
    secret: underlying,
  );

}
