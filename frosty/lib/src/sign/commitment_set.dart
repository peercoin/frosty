import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/identifier.dart';
import 'commitment.dart';

typedef SigningCommitmentPair = (Identifier, SigningCommitment);
typedef SigningCommitmentList = List<SigningCommitmentPair>;

/// Holds the public commitments for signature nonces from signing participants
/// as collected by the coordinator and to be shared with each signing
/// participant.
///
/// The protocol also requires that the message is sent to all participants, but
/// the message can be sent seperately and agreed upon before starting the
/// signing process.
class SigningCommitmentSet with Writable {

  final SigningCommitmentList list;

  /// Takes a list of signing commitments with each element containing a tuple
  /// of the participant [Identifier] and the associated [SigningCommitment].
  SigningCommitmentSet(SigningCommitmentList commitments)
    : list = List.from(commitments);

  SigningCommitmentSet.fromReader(BytesReader reader) : this(
    List.generate(
      reader.readUInt16(),
      (i) => (
        Identifier.fromBytes(reader.readSlice(32)),
        SigningCommitment.fromBytes(reader.readVarSlice()),
      ),
    ),
  );

  @override
  void write(Writer writer) {
    writer.writeUInt16(list.length);
    for (final pair in list) {
      writer.writeSlice(pair.$1.toBytes());
      writer.writeVarSlice(pair.$2.toBytes());
    }
  }

}
