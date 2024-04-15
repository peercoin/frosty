import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'invalid_info.dart';
import 'key_info.dart';
import 'group.dart';
import 'public_shares.dart';

/// Contains the group details and public shares used to aggregate a signature
/// from shares.
class AggregateKeyInfo extends KeyInfo {

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

  AggregateKeyInfo.fromReader(BytesReader reader) : this(
    group: GroupKeyInfo.fromReader(reader),
    publicShares: PublicSharesKeyInfo.fromReader(reader),
  );

  @override
  void write(Writer writer) {
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

}
