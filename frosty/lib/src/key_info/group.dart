import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'key_info_with_group_key.dart';
import 'invalid_info.dart';

/// Contains information of a FROST key required for all participants and the
/// coordinator. This includes the group public key and the threshold number.
class GroupKeyInfo extends KeyInfoWithGroupKey {

  /// The public key of the overall FROST key
  @override
  final cl.ECCompressedPublicKey groupKey;
  /// The number of signers required for a signature
  final int threshold;

  /// Takes the FROST key information. If this information is invalid
  /// [InvalidKeyInfo] may be thrown.
  GroupKeyInfo({
    required this.groupKey,
    required this.threshold,
  }) {
    if (threshold < 2) throw InvalidKeyInfo("threshold should at least 2");
  }

  GroupKeyInfo.fromReader(cl.BytesReader reader) : this(
    groupKey: cl.ECCompressedPublicKey(reader.readSlice(33)),
    threshold: reader.readUInt16(),
  );

  /// Convenience constructor to construct from serialised [bytes].
  GroupKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  GroupKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    writer.writeSlice(groupKey.data);
    writer.writeUInt16(threshold);
  }

  @override
  /// Tweaks the group key by a scalar. null may be returned if the scalar was
  /// crafted to lead to an invalid public key.
  GroupKeyInfo? tweak(Uint8List scalar) {
    final newPk = groupKey.tweak(scalar);
    return newPk == null ? null : GroupKeyInfo(
      groupKey: newPk,
      threshold: threshold,
    );
  }

}
