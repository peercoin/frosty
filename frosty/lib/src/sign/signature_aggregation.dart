import 'package:coinlib/coinlib.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/frost_public_info.dart';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'commitment_set.dart';
import 'signature_share.dart';
import 'details.dart';

typedef ShareList = List<(Identifier, SignatureShare)>;

/// Thrown when the signature shares cannot be aggregated into a valid signature
class InvalidAggregation extends MessageException {
  InvalidAggregation(super.message);
}

/// Allows the coordinator to aggregate signature shares taken from selected
/// participants.
class SignatureAggregation {

  /// The final generated signature
  late SchnorrSignature signature;

  SignatureAggregation({
    required SigningCommitmentSet commitments,
    required SignDetails details,
    required ShareList shares,
    required FrostPublicInfo publicInfo,
  }) {

    try {

      final bytes = rust.aggregateSignature(
        nonceCommitments: commitments.nativeList,
        message: details.message,
        merkleRoot: details.mastHash,
        shares: shares.map((s) => rust.IdentifierAndSignatureShare(
            identifier: s.$1.underlying,
            share: s.$2.underlying,
        ),).toList(),
        groupPk: publicInfo.groupPublicKey.data,
        publicShares: publicInfo.publicShares.map(
          (s) => rust.IdentifierAndPublicShare(
            identifier: s.$1.underlying,
            publicShare: s.$2.data,
          ),
        ).toList(),
      );

      signature = SchnorrSignature(bytes);

    } on AnyhowException catch(e) {
      throw InvalidAggregation(e.message);
    }

  }

}
