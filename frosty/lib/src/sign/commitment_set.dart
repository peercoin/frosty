import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'package:frosty/src/identifier.dart';
import 'commitment.dart';

typedef SigningCommitmentMap = Map<Identifier, SigningCommitment>;

/// Holds the public commitments for signature nonces from signing participants
/// as collected by the coordinator and to be shared with each signing
/// participant.
///
/// The protocol also requires that the message is sent to all participants, but
/// the message can be sent seperately and agreed upon before starting the
/// signing process.
class SigningCommitmentSet with cl.Writable {

  final SigningCommitmentMap map;

  /// Takes a list of signing commitments with each element containing a tuple
  /// of the participant [Identifier] and the associated [SigningCommitment].
  SigningCommitmentSet(SigningCommitmentMap commitments)
    : map = Map.unmodifiable(commitments);

  SigningCommitmentSet.fromReader(cl.BytesReader reader) : this(
    {
      for (int i = reader.readUInt16(); i > 0; i--)
        Identifier.fromBytes(reader.readSlice(32)):
        SigningCommitment.fromBytes(reader.readVarSlice()),
    }
  );

  List<rust.IdentifierAndSigningCommitment> get nativeList => map.entries.map(
    (entry) => rust.IdentifierAndSigningCommitment.fromRefs(
      identifier: entry.key.underlying,
      commitment: entry.value.underlying,
    ),
  ).toList();

  @override
  void write(cl.Writer writer) {
    writer.writeUInt16(map.length);
    for (final entry in map.entries) {
      writer.writeSlice(entry.key.toBytes());
      writer.writeVarSlice(entry.value.toBytes());
    }
  }

}
