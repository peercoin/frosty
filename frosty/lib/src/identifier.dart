import "package:coinlib/coinlib.dart";
import "package:flutter_rust_bridge/flutter_rust_bridge.dart";
import "rust_bindings/rust_api.dart" as rust;

/// Thrown when a valid identifier cannot be created
class InvalidIdentifier implements Exception {
  final String error;
  InvalidIdentifier(this.error);
  @override
  String toString() => "InvalidIdentifier: $error";
}

rust.FrostIdentifier _handleGetIdentifier(rust.FrostIdentifier Function() f) {
  try {
    return f();
  } on FrbAnyhowException catch(e) {
    throw InvalidIdentifier(e.anyhow);
  }
}

/// The ID of a participant in a threshold signing group.
///
/// The FROST spec specifies that identifiers should be in the range 1 to n, but
/// any set of unique non-zero secp256k1 scalars can be accepted and may be
/// generated from strings using [fromString()].
///
/// Identifiers can be compared for equality with `==`.
class Identifier {

  final rust.FrostIdentifier underlying;

  Identifier.fromUnderlying(this.underlying);

  /// Creates an identifier from a non-zero 16-bit integer
  Identifier.fromUint16(int i) : underlying = _handleGetIdentifier(
    () => rust.rustApi.identifierFromU16(i: i),
  );

  /// Creates an identifier from an arbitrary string
  Identifier.fromString(String s) : underlying = _handleGetIdentifier(
    () => rust.rustApi.identifierFromString(s: s),
  );

  /// Creates an identifier from a 32-byte non-zero secp256k1 scalar in
  /// big-endian
  Identifier.fromBytes(Uint8List data) : underlying = _handleGetIdentifier(
    () => rust.rustApi.identifierFromBytes(bytes: data),
  );

  /// Obtains the serialised scalar bytes as a big-endian secp256k1 scalar
  Uint8List? bytesCache;
  Uint8List toBytes() => bytesCache ??= rust.rustApi.identifierToBytes(
    identifier: underlying,
  );

  @override
  bool operator ==(Object other)
    => (other is Identifier) && bytesEqual(toBytes(), other.toBytes());

  @override
  int get hashCode
    => toBytes()[1]
    | toBytes()[2] << 8
    | toBytes()[3] << 16
    | toBytes()[4] << 24;

}
