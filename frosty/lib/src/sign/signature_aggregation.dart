import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/helpers/message_exception.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/key_info/aggregate.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'commitment_set.dart';
import 'signature_share.dart';
import 'details.dart';

typedef ShareList = List<(Identifier, SignatureShare)>;

/// Thrown when the signature shares cannot be aggregated into a valid signature
/// and this is not due to an identifiably incorrect signature share (use
/// [InvalidAggregationShare]).
class InvalidAggregation extends MessageException {
  InvalidAggregation(super.message);
}

/// Thrown when a participant provided an invalid share. The participant is
/// identified with [culprit].
class InvalidAggregationShare implements Exception {
  final Identifier? culprit;
  InvalidAggregationShare(this.culprit);
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
    required AggregateKeyInfo info,
  }) {

    try {

      final bytes = rust.aggregateSignature(
        nonceCommitments: commitments.nativeList,
        message: details.message,
        merkleRoot: details.mastHash,
        shares: shares.map(
          (s) => rust.IdentifierAndSignatureShare.fromRefs(
            identifier: s.$1.underlying,
            share: s.$2.underlying,
          ),
        ).toList(),
        groupPk: info.groupKey.data,
        publicShares: info.publicShares.list.map(
          (s) => rust.IdentifierAndPublicShare.fromRef(
            identifier: s.$1.underlying,
            publicShare: s.$2.data,
          ),
        ).toList(),
      );

      signature = SchnorrSignature(bytes);

    } on rust.SignAggregationError_General catch(e) {
      throw InvalidAggregation(e.message);
    } on rust.SignAggregationError_InvalidSignShare catch(e) {
      throw InvalidAggregationShare(Identifier.fromUnderlying(e.culprit));
    }

  }

}
