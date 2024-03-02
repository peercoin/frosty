import 'package:coinlib/coinlib.dart';
import 'identifier.dart';

typedef PublicShareList = List<(Identifier, ECPublicKey)>;

/// Contains the public information for a FROST shared key which should be
/// identical for all participants. This includes the public key, public key
/// shares and signing threshold.
class FrostPublicInfo with Writable {

  /// The public key of the overall FROST key
  final ECPublicKey groupPublicKey;
  /// The public shares for each participant, ordered by identifier
  final PublicShareList publicShares;
  /// The number of signers required for a signature
  final int threshold;

  FrostPublicInfo({
    required this.groupPublicKey,
    required PublicShareList publicShares,
    required this.threshold,
  }) : publicShares = List.from(publicShares)..sort(
      (a, b) => a.$1.compareTo(b.$1),
  ) {

    if (threshold > publicShares.length) {
      throw ArgumentError.value(
        threshold,
        "threshold",
        "shouldn't exceed number of shares (${publicShares.length})",
      );
    }

    if (
      !groupPublicKey.compressed
      || publicShares.any((pk) => !pk.$2.compressed)
    ) {
      throw ArgumentError("FrostPublicInfo cannot accept uncompressed keys");
    }

  }

  @override
  void write(Writer writer) {
    writer.writeSlice(groupPublicKey.data);
    writer.writeUInt16(publicShares.length);
    for (final share in publicShares) {
      writer.writeSlice(share.$1.toBytes());
      writer.writeSlice(share.$2.data);
    }
    writer.writeUInt16(threshold);
  }

}
