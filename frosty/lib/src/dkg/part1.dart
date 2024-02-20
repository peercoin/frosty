import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'public_commitment.dart';

typedef DkgRound1Secret = rust.DkgRound1SecretPackage;

/// The first step to generate a distributed FROST key. This contains a secret
/// and a public commitment, the latter of which is to be shared between all
/// other participants.
class DkgPart1 {

  /// The secret object that is required for round 2 but must be kept secret by
  /// the participant and shared with no-one else. `secret.dispose()` may
  /// be called once the secret is no longer needed.
  late final DkgRound1Secret secret;
  /// The public commitment that must be shared to all other participants
  late final DkgPublicCommitment public;

  /// Starts the DKG process for the participant with the [identifier] and a
  /// [threshold] of [n] signing scheme. There must be at least 2 signers with a
  /// [threshold] of at least 2. The threshold cannot exceed [n].
  ///
  /// The resulting [public] field contains the commitment to share with all
  /// other participants.
  DkgPart1({
    required Identifier identifier,
    required int threshold,
    required int n,
  }) {

    if (n < 2 || n > 0xffff) {
      throw ArgumentError.value(
        n, "n", "should be between 2 and 65535",
      );
    }

    if (threshold < 2 || threshold > n) {
      throw ArgumentError.value(
        threshold, "threshold", "should be between 2 and $n",
      );
    }

    final record = rust.rustApi.dkgPart1(
      identifier: identifier.underlying,
      maxSigners: n,
      minSigners: threshold,
    );

    secret = record.$1;
    public = DkgPublicCommitment.fromUnderlying(record.$2);

  }

}
