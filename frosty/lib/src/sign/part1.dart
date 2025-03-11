import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/sign/commitment.dart';
import 'nonces.dart';

/// The first stage of the signing process where each signing participant
/// generates [nonces] and a [commitment] to those nonces. The [commitment] is
/// to be shared to the signature aggregator with authentication to start the
/// signing process.
class SignPart1 {

  /// To be held by the participant for part2 of the signing process.
  late SigningNonces nonces;

  /// The commitment to the nonces to be shared with the signature aggregator.
  late SigningCommitment commitment;

  /// Generate the nonces using the [privateShare] for additional entropy.
  SignPart1({ required cl.ECPrivateKey privateShare }) {
    final record = rust.signPart1(privateShare: privateShare.data);
    nonces = SigningNonces.fromUnderlying(record.$1);
    commitment = SigningCommitment.fromUnderlying(record.$2);
  }

}
