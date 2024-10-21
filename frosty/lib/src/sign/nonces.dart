import 'dart:typed_data';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/rust_bindings/invalid_object.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';

/// Thrown when bytes are not valid signing nonces
class InvalidSigningNonces extends MessageException {
  InvalidSigningNonces(super.message);
}

/// The nonces share for signatures, to be kept by the signing participant.
class SigningNonces
extends WritableRustObjectWrapper<rust.SigningNonces> {

  SigningNonces.fromUnderlying(super._underlying);

  /// Reads the serialised commitment from a participant and throws
  /// [InvalidSigningNonces] if invalid.
  SigningNonces.fromBytes(Uint8List data) : super(
    handleGetObject(
      () => rust.signingNoncesFromBytes(bytes: data),
      (e) => InvalidSigningNonces(e),
    ),
    data,
  );

  /// Obtains serialised data for the commitment that can be shared with
  /// the signature aggregator.
  @override
  Uint8List serializeImpl() => rust.signingNoncesToBytes(nonces: underlying);

}
