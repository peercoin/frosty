import "dart:typed_data";
import "package:coinlib/coinlib.dart";
import "package:frosty/src/helpers/message_exception.dart";
import "package:frosty/src/rust_bindings/invalid_object.dart";
import "package:frosty/src/rust_bindings/rust_object_wrapper.dart";
import "rust_bindings/rust_api.dart" as rust;

/// Thrown when a valid identifier cannot be created
class InvalidIdentifier extends MessageException {
  InvalidIdentifier(super.message);
}

rust.IdentifierOpaque _handleGetIdentifier(
  rust.IdentifierOpaque Function() f,
) => handleGetObject(f, (e) => InvalidIdentifier(e));

/// The ID of a participant in a threshold signing group.
///
/// The FROST spec specifies that identifiers should be in the range 1 to n, but
/// any set of unique non-zero secp256k1 scalars can be accepted and may be
/// generated from strings using [fromString()].
///
/// Identifiers can be compared for equality with `==`.
class Identifier
  extends WritableRustObjectWrapper<rust.IdentifierOpaque>
  implements Comparable<Identifier> {

  Identifier.fromUnderlying(super.underlying);

  /// Creates an identifier from a non-zero 16-bit integer
  Identifier.fromUint16(int i) : super(_handleGetIdentifier(
    () => rust.identifierFromU16(i: i),
  ),);

  /// Creates an identifier from an arbitrary string
  Identifier.fromString(String s) : super(_handleGetIdentifier(
    () => rust.identifierFromString(s: s),
  ),);

  /// Creates an identifier from a 32-byte non-zero secp256k1 scalar in
  /// big-endian
  Identifier.fromBytes(Uint8List data) : super(
    _handleGetIdentifier(
      () => rust.identifierFromBytes(bytes: data),
    ),
    data,
  );

  /// Obtains the serialised scalar bytes as a big-endian secp256k1 scalar
  @override
  Uint8List serializeImpl() => rust.identifierToBytes(
    identifier: underlying,
  );

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is Identifier && bytesEqual(toBytes(), other.toBytes())
  );

  @override
  int get hashCode
    => toBytes()[1]
    | toBytes()[2] << 8
    | toBytes()[3] << 16
    | toBytes()[4] << 24;

  @override
  int compareTo(Identifier other) => compareBytes(toBytes(), other.toBytes());

  @override
  String toString() => bytesToHex(toBytes());

}
