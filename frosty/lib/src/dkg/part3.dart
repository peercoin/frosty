import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/private_key_share.dart';
import 'package:frosty/src/public_key_shares.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'commitment_set.dart';
import 'part1.dart';
import 'part2.dart';
import 'share_to_give.dart';

/// Thrown when data provided into part 3 is not valid
class InvalidPart3 extends MessageException{
  InvalidPart3(super.message);
}

/// The third and final part of the DKG. This produces the final
/// [PrivateKeyShare] for the participant and the [PublicKeyShares] that can be
/// used by a coordinator to verify signature shares.
///
/// The information that went into producing the key can be diposed of
/// afterwards. This includes the [DkgRound2Secret], [DkgCommitmentSet] and
/// [DkgShareToGive] shares.
class DkgPart3 {

  /// The share of the key for the participant
  late PrivateKeyShare privateKeyShare;

  /// The public shares of each participant so the coordinator can verify
  /// signature shares
  late PublicKeyShares publicKeyShares;

  /// Takes the secret from [DkgPart2.secret], the commitments from [DkgPart1]
  /// and all received shares from [DkgPart2]. The received shares should be
  /// authenticated via a signature from the sending participant.
  DkgPart3({
    required DkgRound2Secret round2Secret,
    required DkgCommitmentSet commitments,
    required List<(Identifier, DkgShareToGive)> receivedShares,
  }) {

    try {

      final record = rust.rustApi.dkgPart3(
        round2Secret: round2Secret.underlying,
        round1Commitments: commitments.nativeList,
        round2Shares: receivedShares.map(
          (v) => rust.DkgRound2IdentifierAndShare(
            identifier: v.$1.underlying,
            secret: v.$2.underlying,
          ),
        ).toList(),
      );

      privateKeyShare = PrivateKeyShare.fromUnderlying(record.$1);
      publicKeyShares = PublicKeyShares.fromUnderlying(record.$2);

    } on FrbAnyhowException catch(e) {
      throw InvalidPart3(e.anyhow);
    }

  }

}
