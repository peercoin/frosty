import 'dart:typed_data';

import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/rust_bindings/invalid_object.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';

import 'public_commitment.dart';

/// Thrown when bytes are not a valid round-one DKG secret.
class InvalidDkgRound1Secret extends MessageException {
  InvalidDkgRound1Secret(super.message);
}

/// The secret from part 1 of the DKG that is to be kept for part 2.
///
/// Bytes returned by [toBytes] contain sensitive secret material. Callers that
/// persist them must use authenticated encryption and delete them when they are
/// no longer needed. Clear plaintext byte buffers after use. After part 2 this
/// object can be disposed with [dispose()], which does not erase exported
/// buffers or other copies made by the runtime.
/// Store the ceremony ID, participant identity, and agreed commitment-set hash
/// together with the secret under authenticated encryption. On restore, verify
/// that context and reject completed or abandoned ceremonies; these bytes alone
/// do not provide replay protection.
class DkgRound1Secret
    extends WritableRustObjectWrapper<rust.DkgRound1SecretOpaque> {
  DkgRound1Secret.fromUnderlying(super._underlying);

  /// Restores a round-one secret previously obtained from [toBytes]. The input
  /// buffer is not retained and can be cleared after this constructor returns.
  DkgRound1Secret.fromBytes(Uint8List data)
    : super(
        handleGetObject(
          () => rust.dkgRound1SecretFromBytes(bytes: data),
          (e) => InvalidDkgRound1Secret(e),
        ),
      );

  /// Exports a fresh, uncached buffer of sensitive secret material so this DKG
  /// round can be resumed with the same participant and commitment set.
  @override
  Uint8List toBytes() => serializeImpl();

  @override
  Uint8List serializeImpl() => rust.dkgRound1SecretToBytes(secret: underlying);
}

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
      throw ArgumentError.value(n, "n", "should be between 2 and 65535");
    }

    if (threshold < 2 || threshold > n) {
      throw ArgumentError.value(
        threshold,
        "threshold",
        "should be between 2 and $n",
      );
    }

    final record = rust.dkgPart1(
      identifier: identifier.underlying,
      maxSigners: n,
      minSigners: threshold,
    );

    secret = DkgRound1Secret.fromUnderlying(record.$1);
    public = DkgPublicCommitment.fromUnderlying(record.$2);
  }
}
