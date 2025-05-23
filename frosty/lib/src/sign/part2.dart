import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/key_info/signing.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'details.dart';
import 'nonces.dart';
import 'commitment_set.dart';
import 'signature_share.dart';

/// Thrown when data provided into part 2 of the sign process is not valid
class InvalidSignPart2 extends MessageException {
  InvalidSignPart2(super.message);
}

/// Generates the signature [share] to share with the signature
/// aggregator/coordinator.
class SignPart2 {

  late SignatureShare share;

  /// After the signature share is generated, the [ourNonces] should be
  /// disposed. The [commitments] are also no longer needed.
  SignPart2({
    required Identifier identifier,
    required SignDetails details,
    required SigningNonces ourNonces,
    required SigningCommitmentSet commitments,
    required SigningKeyInfo info,
  }) {

    try {

      share = SignatureShare.fromUnderlying(
        rust.signPart2(
          noncesCommitments: commitments.nativeList,
          message: details.message,
          merkleRoot: details.mastHash,
          signingNonces: ourNonces.underlying,
          identifier: identifier.underlying,
          privateShare: info.private.share.data,
          groupPk: info.groupKey.data,
          threshold: info.group.threshold,
        ),
      );

    } on AnyhowException catch(e) {
      throw InvalidSignPart2(e.message);
    }

  }

}
