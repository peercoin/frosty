import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'key_info_with_group_key.dart';
import 'invalid_info.dart';
import 'group.dart';
import 'public_shares.dart';

/// Contains the group details and public shares used to aggregate a signature
/// from shares.
class AggregateKeyInfo extends KeyInfoWithGroupKey {

  final GroupKeyInfo group;
  final PublicSharesKeyInfo publicShares;

  static void validateGroupWithPublicShares(
    GroupKeyInfo group, PublicSharesKeyInfo publicShares,
  ) {
    if (group.threshold > publicShares.list.length) {
      throw InvalidKeyInfo(
        "threshold shouldn't exceed ${publicShares.list.length}",
      );
    }
  }

  AggregateKeyInfo({
    required this.group,
    required this.publicShares,
  }) {
    validateGroupWithPublicShares(group, publicShares);
  }

  AggregateKeyInfo.fromReader(cl.BytesReader reader) : this(
    group: GroupKeyInfo.fromReader(reader),
    publicShares: PublicSharesKeyInfo.fromReader(reader),
  );

  /// Convenience constructor to construct from serialised [bytes].
  AggregateKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  AggregateKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    group.write(writer);
    publicShares.write(writer);
  }

  @override
  /// Tweaks the aggregate key info by a scalar. null may be returned if the
  /// scalar was crafted to lead to an invalid key or shares.
  AggregateKeyInfo? tweak(Uint8List scalar) {
    final newGroup = group.tweak(scalar);
    final newShares = publicShares.tweak(scalar);
    return newGroup == null || newShares == null
      ? null
      : AggregateKeyInfo(group: newGroup, publicShares: newShares);
  }

  @override
  cl.ECCompressedPublicKey get groupKey => group.groupKey;

}
