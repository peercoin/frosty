import 'dart:typed_data';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/rust_bindings/invalid_object.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';

/// Thrown when bytes are not a valid signing commitment
class InvalidSigningCommitment extends MessageException {
  InvalidSigningCommitment(super.message);
}

/// The commitment to the signature nonce to be used for signing. This should be
/// shared with the signature aggregator.
class SigningCommitment
extends WritableRustObjectWrapper<rust.FrostRound1SigningCommitments> {

  SigningCommitment.fromUnderlying(super._underlying);

  /// Reads the serialised commitment from a participant and throws
  /// [InvalidSigningCommitment] if invalid.
  SigningCommitment.fromBytes(Uint8List data) : super(
    handleGetObject(
      () => rust.signingCommitmentFromBytes(bytes: data),
      (e) => InvalidSigningCommitment(e),
    ),
    data,
  );

  /// Obtains serialised data for the commitment that can be shared with
  /// the signature aggregator.
  @override
  Uint8List serializeImpl() => rust.signingCommitmentToBytes(
    commitment: underlying,
  );

}
