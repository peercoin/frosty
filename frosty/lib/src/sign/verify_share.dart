import 'package:coinlib/coinlib.dart' as cl;
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/identifier.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'commitment_set.dart';
import 'details.dart';
import 'signature_share.dart';

bool verifySignatureShare({
  required SigningCommitmentSet commitments,
  required SignDetails details,
  required Identifier id,
  required SignatureShare share,
  required cl.ECCompressedPublicKey publicShare,
  required cl.ECCompressedPublicKey groupKey,
}) {

  try {
    rust.verifySignatureShare(
      noncesCommitments: commitments.nativeList,
      message: details.message,
      merkleRoot: details.mastHash,
      identifier: id.underlying,
      share: share.underlying,
      publicShare: publicShare.data,
      groupPk: groupKey.data,
    );
  } on AnyhowException {
    return false;
  }

  return true;

}
