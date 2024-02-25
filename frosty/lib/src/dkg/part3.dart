import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'public_commitment.dart';
import 'part2.dart';
import 'shared_secret.dart';

/// Thrown when data provided into part 3 is not valid
class InvalidPart3 implements Exception {
  final String error;
  InvalidPart3(this.error);
  @override
  String toString() => "InvalidPart3: $error";
}

class DkgPart3 {

  DkgPart3({
    required DkgRound2Secret round2Secret,
    required List<(Identifier, DkgPublicCommitment)> identifierCommitments,
  }) {

    try {

      final record = rust.rustApi.dkgPart2(
        round1Secret: round1Secret.underlying,
        round1Commitments: identifierCommitments.map(
          (v) => rust.DkgCommitmentForIdentifier(
            identifier: v.$1.underlying,
            commitment: v.$2.underlying,
          ),
        ).toList(),
      );

      secret = DkgRound2Secret.fromUnderlying(record.$1);
      secretsToShare = record.$2.map(
        (s) => (
          Identifier.fromUnderlying(s.identifier),
          DkgSharedSecret.fromUnderlying(s.secret),
        ),
      ).toList();

    } on FrbAnyhowException catch(e) {
      throw InvalidPart2(e.anyhow);
    }

  }

}
