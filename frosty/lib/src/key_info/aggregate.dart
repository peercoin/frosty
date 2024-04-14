import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/key_info/invalid_info.dart';
import 'group.dart';
import 'public_shares.dart';

/// Contains the group details and public shares used to aggregate a signature
/// from shares.
class AggregateKeyInfo with Writable {

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

}
