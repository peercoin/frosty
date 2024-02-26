import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';

/// Thrown when bytes are not a valid shared secret
class InvalidShareToGive implements Exception {
  final String error;
  InvalidShareToGive(this.error);
  @override
  String toString() => "InvalidShareToGive: $error";
}

rust.DkgRound2Package _handleGetSecret(
  rust.DkgRound2Package Function() f,
) {
  try {
    return f();
  } on FrbAnyhowException catch(e) {
    throw InvalidShareToGive(e.anyhow);
  }
}

/// A secret share that is to be shared to another participant or a secret share
/// that was shared from another participant.
///
/// These must be encrypted and authenticated so that only the recipient has the
/// secret and they know whom it was sent from.
///
/// After this secret has been successfully broadcast to the participant, it
/// should be disposed with [dispose()].
class DkgShareToGive extends RustObjectWrapper<rust.DkgRound2Package> {

  DkgShareToGive.fromUnderlying(super._underlying);

  /// Reads the serialised secret from a participant and throws
  /// [InvalidShareToGive] if invalid.
  DkgShareToGive.fromBytes(Uint8List data) : super(
    _handleGetSecret(
      () => rust.rustApi.shareToGiveFromBytes(bytes: data),
    ),
  );

  /// Obtains serialised data for the secret that should only be shared to the
  /// recipient participant. Shared secrets must be encrypted and authenticated
  /// and must only be sent to the required recipient.
  Uint8List toBytes() => rust.rustApi.shareToGiveToBytes(share: underlying);

}
