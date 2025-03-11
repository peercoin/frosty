import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/identifier.dart';
import 'key_info.dart';
import 'invalid_info.dart';

typedef PublicShareList = List<(Identifier, cl.ECCompressedPublicKey)>;

/// Contains the public shares for a FROST shared key
class PublicSharesKeyInfo extends KeyInfo {

  /// The public shares for each participant, ordered by identifier
  final PublicShareList list;

  /// Takes the public shares for a FROST key. If this information is invalid
  /// [InvalidKeyInfo] may be thrown.
  PublicSharesKeyInfo({
    required PublicShareList publicShares,
  }) : list = List.from(publicShares)..sort(
      (a, b) => a.$1.compareTo(b.$1),
  ) {

    if (
      publicShares.map((share) => share.$1).toSet().length
      != publicShares.length
    ) {
      throw InvalidKeyInfo("Duplicate identifier");
    }

  }

  PublicSharesKeyInfo.fromReader(cl.BytesReader reader) : this(
    publicShares: List.generate(
      reader.readUInt16(),
      (i) => (
        Identifier.fromBytes(reader.readSlice(32)),
        cl.ECCompressedPublicKey(reader.readSlice(33)),
      ),
    ),
  );

  /// Convenience constructor to construct from serialised [bytes].
  PublicSharesKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  PublicSharesKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    writer.writeUInt16(list.length);
    for (final share in list) {
      writer.writeSlice(share.$1.toBytes());
      writer.writeSlice(share.$2.data);
    }
  }

  @override
  /// Tweaks the public shares by a scalar. null may be returned if the scalar
  /// was crafted to lead to any invalid public key.
  PublicSharesKeyInfo? tweak(Uint8List scalar) {

    final newShares = list.map(
      (share) {
        final newPk = share.$2.tweak(scalar);
        return newPk == null ? null : (share.$1, newPk);
      }
    ).toList();

    return newShares.any((share) => share == null)
      ? null
      : PublicSharesKeyInfo(
        publicShares: newShares.map((share) => share!).toList(),
      );

  }

}
