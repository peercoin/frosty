import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/frost_private_info.dart';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'commitment_set.dart';
import 'part1.dart';
import 'signature_share.dart';

/// Thrown when data provided into part 2 of the sign process is not valid
class InvalidSignPart2 extends MessageException {
  InvalidSignPart2(super.message);
}

/// Generates the signature [share] to share with the signature
/// aggregator/coordinator.
class SignPart2 {

  late SignatureShare share;

  /// After the signature share is generated, the [ourNonce] should be disposed.
  /// The [commitments] are also no longer needed.
  ///
  /// The message should be agreed upon and for Peercoin transactions is the
  /// taproot signature hash.
  SignPart2({
    required Identifier identifier,
    required Uint8List message,
    required SignNonce ourNonce,
    required SigningCommitmentSet commitments,
    required FrostPrivateInfo privateInfo,
  }) {

    try {

      share = SignatureShare.fromUnderlying(
        rust.rustApi.signPart2(
          nonceCommitments: commitments.nativeList,
          message: message,
          signingNonce: ourNonce.underlying,
          identifier: identifier.underlying,
          privateShare: privateInfo.privateShare.data,
          groupPk: privateInfo.public.groupPublicKey.data,
          threshold: privateInfo.public.threshold,
        ),
      );

    } on FrbAnyhowException catch(e) {
      throw InvalidSignPart2(e.anyhow);
    }

  }

}
