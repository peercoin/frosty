import 'package:coinlib/coinlib.dart';
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
  /// It must be authenticated as belonging to the participant.
  late SigningCommitment commitment;

  /// Generate the nonces using the [privateShare] for additional entropy.
  SignPart1({ required ECPrivateKey privateShare }) {
    final record = rust.signPart1(privateShare: privateShare.data);
    nonces = SigningNonces.fromUnderlying(record.$1);
    commitment = SigningCommitment.fromUnderlying(record.$2);
  }

}
