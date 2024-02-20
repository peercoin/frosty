import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'public_commitment.dart';
import 'part1.dart';
import 'shared_secret.dart';

/// Thrown when data provided into part 2 is not valid
class InvalidPart2 implements Exception {
  final String error;
  InvalidPart2(this.error);
  @override
  String toString() => "InvalidPart2: $error";
}

typedef DkgRound2Secret = rust.DkgRound2SecretPackage;
typedef Round2 = (DkgRound2Secret, List<rust.DkgRound2SecretToShare>);

Round2 _handleGetRound2(Round2 Function() f) {
  try {
    return f();
  } on FrbAnyhowException catch(e) {
    throw InvalidPart2(e.anyhow);
  }
}

/// The second step to generate a distributed FROST key. This provides the
/// secrets that must be shared to the participants of each given identifier
/// without revealing them to anyone else. Authentication and encryption must be
/// used to share the secrets.
///
/// After this step, the old [DkgPart1.secret] can be disposed and a new secret
/// will be stored in preparation for part 3.
class DkgPart2 {

  /// Secret to be kept for part 3
  late final DkgRound2Secret secret;
  /// Secrets that are to be shared to participants given by each [Identifier].
  /// They must be encrypted and authenticated and not shared with anyone else.
  late final List<(Identifier, DkgSharedSecret)> secretsToShare;

  /// Takes the secret from [DkgPart1.secret] and a list of public commitments
  /// and identifiers from all of the other participants.
  DkgPart2({
    required DkgRound1Secret round1Secret,
    required List<(Identifier, DkgPublicCommitment)> identifierCommitments,
  }) {

    final record = _handleGetRound2(() => rust.rustApi.dkgPart2(
      round1Secret: round1Secret,
      round1Commitments: identifierCommitments.map(
        (v) => rust.DkgCommitmentForIdentifier(
          identifier: v.$1.underlying,
          commitment: v.$2.underlying,
        ),
      ).toList(),
    ),);

    secret = record.$1;
    secretsToShare = record.$2.map(
      (s) => (
        Identifier.fromUnderlying(s.identifier),
        DkgSharedSecret.fromUnderlying(s.secret),
      ),
    ).toList();

  }

}
