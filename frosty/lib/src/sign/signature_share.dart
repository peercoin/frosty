import 'dart:typed_data';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/rust_bindings/invalid_object.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';

/// Thrown when bytes are not a valid signature share
class InvalidSignatureShare extends MessageException {
  InvalidSignatureShare(super.message);
}

/// The signature share to be sent to the aggregator/coordinator over an
/// authenticated channel.
class SignatureShare
extends WritableRustObjectWrapper<rust.FrostRound2SignatureShare> {

  SignatureShare.fromUnderlying(super._underlying);

  /// Reads the serialised share from a participant and throws
  /// [InvalidSignatureShare] if invalid.
  SignatureShare.fromBytes(Uint8List data) : super(
    handleGetObject(
      () => rust.signatureShareFromBytes(bytes: data),
      (e) => InvalidSignatureShare(e),
    ),
    data,
  );

  /// Obtains serialised data for the signature share that can be shared with
  /// the signature aggregator.
  @override
  Uint8List serializeImpl() => rust.signatureShareToBytes(
    share: underlying,
  );

}
