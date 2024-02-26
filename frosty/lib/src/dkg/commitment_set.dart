import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'public_commitment.dart';
import 'package:frosty/src/identifier.dart';

typedef CommitmentPair = (Identifier, DkgPublicCommitment);
typedef CommitmentList = List<CommitmentPair>;

/// Holds the list of public commitments associated with each identifier. These
/// must be the same across all participants. Each participant should verify
/// that all other participants have the same set by receiving a signed [hash]
/// of commitments from each participant and verifying that they are the same.
class DkgCommitmentSet {

  final CommitmentList list;

  /// Takes a list of commitments with each element containing a tuple of the
  /// [Identifier] followed by the associated [DkgPublicCommitment].
  DkgCommitmentSet(CommitmentList commitments)
    // Order commitments to ensure consistency
    : list = List.from(commitments)..sort(
      (a, b) => a.$1.compareTo(b.$1),
    );

  Uint8List? _hashCache;
  Uint8List get hash => _hashCache ??= sha256Hash(
    Uint8List.fromList([
      for (final commitment in list)
      ...commitment.$2.toBytes(),
    ],),
  );

  List<rust.DkgCommitmentForIdentifier> get nativeList => list.map(
    (v) => rust.DkgCommitmentForIdentifier(
      identifier: v.$1.underlying,
      commitment: v.$2.underlying,
    ),
  ).toList();

}
