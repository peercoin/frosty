import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/key_info/aggregate.dart';
import 'package:frosty/src/key_info/signing.dart';
import 'group.dart';
import 'public_shares.dart';
import 'private.dart';

/// Contains all details for a given participant, including the group key,
/// threshold, public shares and private share.
class ParticipantKeyInfo with Writable {

  final GroupKeyInfo group;
  final PublicSharesKeyInfo publicShares;
  final PrivateKeyInfo private;

  ParticipantKeyInfo({
    required this.group,
    required this.publicShares,
    required this.private,
  }) {
    AggregateKeyInfo.validateGroupWithPublicShares(group, publicShares);
  }

  ParticipantKeyInfo.fromReader(BytesReader reader) : this(
    group: GroupKeyInfo.fromReader(reader),
    publicShares: PublicSharesKeyInfo.fromReader(reader),
    private: PrivateKeyInfo.fromReader(reader),
  );

  @override
  void write(Writer writer) {
    group.write(writer);
    publicShares.write(writer);
    private.write(writer);
  }

  /// Get only the information required for signing shares
  SigningKeyInfo get signing => SigningKeyInfo(
    group: group,
    private: private,
  );

  /// Get only the information required for signature aggregation
  AggregateKeyInfo get aggregate => AggregateKeyInfo(
    group: group,
    publicShares: publicShares,
  );

}
