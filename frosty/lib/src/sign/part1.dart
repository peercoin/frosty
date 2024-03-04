import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/rust_bindings/rust_object_wrapper.dart';
import 'package:frosty/src/sign/commitment.dart';

class SignNonce extends RustObjectWrapper<rust.FrostRound1SigningNonces> {
  SignNonce.fromUnderlying(super._underlying);
}

/// The first stage of the signing process where each signing participant
/// generates a [nonce] and [commitment] to that nonce. The [commitment] is to
/// be shared to the signature aggregator with authentication to start the
/// signing process.
class SignPart1 {

  /// To be held by the participant for part2 of the signing process. This
  /// includes the two one-time values used for generating the signature nonce.
  late SignNonce nonce;

  /// The commitment to the nonce to be shared with the signature aggregator. It
  /// must be authneticated as belonging to the participant.
  late SigningCommitment commitment;

  /// Generate the nonce using the [privateShare] for additional entropy.
  SignPart1({
    required ECPrivateKey privateShare,
  }) {
    final record = rust.rustApi.signPart1(privateShare: privateShare.data);
    nonce = SignNonce.fromUnderlying(record.$1);
    commitment = SigningCommitment.fromUnderlying(record.$2);
  }

}
