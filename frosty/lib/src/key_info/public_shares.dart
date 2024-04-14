import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/identifier.dart';

import 'invalid_info.dart';

typedef PublicShareList = List<(Identifier, ECPublicKey)>;

/// Contains the public shares for a FROST shared key
class PublicSharesKeyInfo with Writable {

  /// The public shares for each participant, ordered by identifier
  final PublicShareList list;

  /// Takes the public shares for a FROST key. If this information is invalid
  /// [InvalidKeyInfo] may be thrown.
  PublicSharesKeyInfo({
    required PublicShareList publicShares,
  }) : list = List.from(publicShares)..sort(
      (a, b) => a.$1.compareTo(b.$1),
  ) {

    if (publicShares.any((pk) => !pk.$2.compressed)) {
      throw InvalidKeyInfo(
        "PublicSharesKeyInfo cannot accept uncompressed keys",
      );
    }

    if (
      publicShares.map((share) => share.$1).toSet().length
      != publicShares.length
    ) {
      throw InvalidKeyInfo("Duplicate identifier");
    }

  }

  PublicSharesKeyInfo.fromReader(BytesReader reader) : this(
    publicShares: List.generate(
      reader.readUInt16(),
      (i) => (
        Identifier.fromBytes(reader.readSlice(32)),
        ECPublicKey(reader.readSlice(33)),
      ),
    ),
  );

  @override
  void write(Writer writer) {
    writer.writeUInt16(list.length);
    for (final share in list) {
      writer.writeSlice(share.$1.toBytes());
      writer.writeSlice(share.$2.data);
    }
  }

}
