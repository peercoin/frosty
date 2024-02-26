import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/key_share.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'commitment_set.dart';
import 'part2.dart';
import 'share_to_give.dart';

/// Thrown when data provided into part 3 is not valid
class InvalidPart3 implements Exception {
  final String error;
  InvalidPart3(this.error);
  @override
  String toString() => "InvalidPart3: $error";
}

/// The third and final part of the DKG.
class DkgPart3 {

  late KeyShare keyShare;

  DkgPart3({
    required DkgRound2Secret round2Secret,
    required DkgCommitmentSet commitments,
    required List<(Identifier, DkgShareToGive)> receivedShares,
  }) {

    try {

      keyShare = KeyShare.fromUnderlying(
        rust.rustApi.dkgPart3(
          round2Secret: round2Secret.underlying,
          round1Commitments: commitments.nativeList,
          round2Shares: receivedShares.map(
            (v) => rust.DkgRound2IdentifierAndShare(
              identifier: v.$1.underlying,
              secret: v.$2.underlying,
            ),
          ).toList(),
        ),
      );

    } on FrbAnyhowException catch(e) {
      throw InvalidPart3(e.anyhow);
    }

  }

}
