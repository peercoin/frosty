import 'package:coinlib/coinlib.dart';
import 'helpers/message_exception.dart';
import 'identifier.dart';

/// Thrown if the public information is not valid
class InvalidPublicInfo extends MessageException {
  InvalidPublicInfo(super.message);
}

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

  /// Takes the public FROST key information. If this information is invalid
  /// [InvalidPublicInfo] may be thrown.
  FrostPublicInfo({
    required this.groupPublicKey,
    required PublicShareList publicShares,
    required this.threshold,
  }) : publicShares = List.from(publicShares)..sort(
      (a, b) => a.$1.compareTo(b.$1),
  ) {

    if (threshold > publicShares.length || threshold < 2) {
      throw InvalidPublicInfo(
        "threshold should be between 2 and ${publicShares.length}",
      );
    }

    if (
      !groupPublicKey.compressed
      || publicShares.any((pk) => !pk.$2.compressed)
    ) {
      throw InvalidPublicInfo("FrostPublicInfo cannot accept uncompressed keys");
    }

    if (
      publicShares.map((share) => share.$1).toSet().length
      != publicShares.length
    ) {
      throw InvalidPublicInfo("Duplicate identifier");
    }

  }

  FrostPublicInfo.fromReader(BytesReader reader) : this(
    groupPublicKey: ECPublicKey(reader.readSlice(33)),
    publicShares: List.generate(
      reader.readUInt16(),
      (i) => (
        Identifier.fromBytes(reader.readSlice(32)),
        ECPublicKey(reader.readSlice(33)),
      ),
    ),
    threshold: reader.readUInt16(),
  );

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
