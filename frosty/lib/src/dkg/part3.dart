import 'package:coinlib/coinlib.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/key_info/group.dart';
import 'package:frosty/src/key_info/participant.dart';
import 'package:frosty/src/key_info/private.dart';
import 'package:frosty/src/key_info/public_shares.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'commitment_set.dart';
import 'part1.dart';
import 'part2.dart';
import 'share_to_give.dart';

/// Thrown when data provided into part 3 is not valid
class InvalidPart3 extends MessageException{
  InvalidPart3(super.message);
}

/// The third and final part of the DKG. This provides the [participantInfo]
/// which allows the participant to produce signature shares.
///
/// The information that went into producing the key can be diposed of
/// afterwards. This includes the [DkgRound2Secret], [DkgCommitmentSet] and
/// [DkgShareToGive] shares.
class DkgPart3 {

  /// All the information required for a participant to begin producing
  /// signature shares.
  late ParticipantKeyInfo participantInfo;

  /// Takes the participant's [identifier], the secret from [DkgPart2.secret],
  /// the commitments from [DkgPart1] and all received shares from [DkgPart2].
  ///
  /// The received shares should be authenticated via a signature from the
  /// sending participant.
  DkgPart3({
    required Identifier identifier,
    required DkgRound2Secret round2Secret,
    required DkgCommitmentSet commitments,
    required Map<Identifier, DkgShareToGive> receivedShares,
  }) {

    try {

      final record = rust.dkgPart3(
        round2Secret: round2Secret.underlying,
        round1Commitments: commitments.nativeListForId(identifier),
        round2Shares: receivedShares.entries.map(
          (v) => rust.DkgRound2IdentifierAndShare(
            identifier: v.key.underlying,
            secret: v.value.underlying,
          ),
        ).toList(),
      );

      participantInfo = ParticipantKeyInfo(

        group: GroupKeyInfo(
          publicKey: ECPublicKey(record.groupPk),
          threshold: record.threshold,
        ),

        publicShares: PublicSharesKeyInfo(
          publicShares: [
            for (final share in record.publicKeyShares) (
              Identifier.fromUnderlying(share.identifier),
              ECPublicKey(share.publicShare),
            ),
          ],
        ),

        private: PrivateKeyInfo(
           identifier: Identifier.fromUnderlying(record.identifier),
           share: ECPrivateKey(record.privateShare),
        ),

      );

    } on AnyhowException catch(e) {
      throw InvalidPart3(e.message);
    }

  }

}
