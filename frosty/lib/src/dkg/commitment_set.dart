import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'public_commitment.dart';
import 'package:frosty/src/identifier.dart';

typedef DkgCommitmentPair = (Identifier, DkgPublicCommitment);
typedef DkgCommitmentList = List<DkgCommitmentPair>;

/// Holds the list of public commitments associated with each identifier. These
/// must be the same across all participants. Each participant should verify
/// that all other participants have the same set by receiving a signed [hash]
/// of commitments from each participant and verifying that they are the same.
class DkgCommitmentSet with Writable {

  final DkgCommitmentList list;

  /// Takes a list of commitments with each element containing a tuple of the
  /// [Identifier] followed by the associated [DkgPublicCommitment].
  DkgCommitmentSet(DkgCommitmentList commitments)
    // Order commitments to ensure consistency
    : list = List.from(commitments)..sort(
      (a, b) => a.$1.compareTo(b.$1),
    );

  DkgCommitmentSet.fromReader(BytesReader reader) : this(
    List.generate(
      reader.readUInt16(),
      (i) => (
        Identifier.fromBytes(reader.readSlice(32)),
        DkgPublicCommitment.fromBytes(reader.readVarSlice()),
      ),
    ),
  );

  Uint8List? _hashCache;
  Uint8List get hash => _hashCache ??= sha256Hash(
    Uint8List.fromList([
      for (final commitment in list)
      ...commitment.$2.toBytes(),
    ],),
  );

  /// Obtains the underlying native list to past to Rust with the entry removed
  /// for the calling participant given by [id].
  List<rust.DkgCommitmentForIdentifier> nativeListForId(Identifier id)
    => list.where((e) => e.$1 != id).map(
      (v) => rust.DkgCommitmentForIdentifier(
        identifier: v.$1.underlying,
        commitment: v.$2.underlying,
      ),
    ).toList();

  @override
  void write(Writer writer) {
    writer.writeUInt16(list.length);
    for (final pair in list) {
      writer.writeSlice(pair.$1.toBytes());
      writer.writeVarSlice(pair.$2.toBytes());
    }
  }

}
