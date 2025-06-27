import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'key_info_with_group_key.dart';
import 'aggregate.dart';
import 'signing.dart';
import 'group.dart';
import 'public_shares.dart';
import 'private.dart';

/// Contains all details for a given participant, including the group key,
/// threshold, public shares and private share.
class ParticipantKeyInfo extends KeyInfoWithGroupKey {

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

  ParticipantKeyInfo.fromReader(cl.BytesReader reader) : this(
    group: GroupKeyInfo.fromReader(reader),
    publicShares: PublicSharesKeyInfo.fromReader(reader),
    private: PrivateKeyInfo.fromReader(reader),
  );

  /// Convenience constructor to construct from serialised [bytes].
  ParticipantKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  ParticipantKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
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

  @override
  /// Tweaks the signing key info by a scalar. null may be returned if the
  /// scalar was crafted to lead to an invalid key or private share.
  ParticipantKeyInfo? tweak(Uint8List scalar) {
    final newGroup = group.tweak(scalar);
    final newShares = publicShares.tweak(scalar);
    final newPrivate = private.tweak(scalar);
    return newGroup == null || newShares == null || newPrivate == null
      ? null
      : ParticipantKeyInfo(
        group: newGroup,
        publicShares: newShares,
        private: newPrivate,
      );
  }

  /// Constructs the private key of the FROST key using the participant's
  /// private share with the shares of threshold-1 other participants that are
  /// provided with [privateShares] containing the identifiers and associated
  /// private key shares.
  ///
  /// See [AggregateKeyInfo.constructPrivateKey].
  cl.ECPrivateKey constructPrivateKey(PrivateShareList privateShares)
    => aggregate.constructPrivateKey(
      [...privateShares, (private.identifier, private.share)],
    );

  @override
  cl.ECCompressedPublicKey get groupKey => group.groupKey;

}
