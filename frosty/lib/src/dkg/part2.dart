import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';
import 'commitment_set.dart';
import 'part1.dart';
import 'share_to_give.dart';

/// The secret from part 2 that is to be held until part 3. After part 3 this
/// can be disposed of with [dispose()].
class DkgRound2Secret extends RustObjectWrapper<rust.DkgRound2SecretPackage> {
  DkgRound2Secret.fromUnderlying(super._underlying);
}

/// Thrown when data provided into part 2 is not valid
class InvalidPart2 extends MessageException {
  InvalidPart2(super.message);
}

/// Thrown when a participant does not provide a valid commitment
/// proof-of-knowledge. [culprit] contains the identifier of the participant
/// with the invalid commitment. There may be other participants with invalid
/// proof-of-knowledge but only one of them is provided.
class InvalidPart2ProofOfKnowledge implements Exception {
  final Identifier? culprit;
  InvalidPart2ProofOfKnowledge(this.culprit);
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
  /// Secret shares that are to be shared to participants given by each
  /// [Identifier]. They must be encrypted and authenticated and not shared with
  /// anyone else.
  late final List<(Identifier, DkgShareToGive)> sharesToGive;

  /// Takes the secret from [DkgPart1.secret] and a list of public commitments
  /// and identifiers from all of the other participants.
  /// The [commitments] must be the same as received by all other participants.
  /// The participant should check the signatures from each participant of the
  /// commitment hashes.
  DkgPart2({
    required DkgRound1Secret round1Secret,
    required DkgCommitmentSet commitments,
  }) {

    try {

      final record = rust.dkgPart2(
        round1Secret: round1Secret.underlying,
        round1Commitments: commitments.nativeList,
      );

      secret = DkgRound2Secret.fromUnderlying(record.$1);
      sharesToGive = record.$2.map(
        (s) => (
          Identifier.fromUnderlying(s.identifier),
          DkgShareToGive.fromUnderlying(s.secret),
        ),
      ).toList();

    } on rust.DkgRound2Error_General catch(e) {
      throw InvalidPart2(e.message);
    } on rust.DkgRound2Error_InvalidProofOfKnowledge catch(e) {
      throw InvalidPart2ProofOfKnowledge(Identifier.fromUnderlying(e.culprit));
    }

  }

}
