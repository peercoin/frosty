import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/identifier.dart';

/// Contains the private share required for a participant to submit signature
/// shares for a FROST key.
class PrivateKeyInfo with Writable {

  /// The identifier of the participant who owns the [share].
  final Identifier identifier;
  /// The key share owned by the participant which must remain confidential.
  final ECPrivateKey share;

  /// Provides the private key share and participant identifier. The identifier
  /// and private share are assumed to belong to a public share in the FROST
  /// key.
  PrivateKeyInfo({
    required this.identifier,
    required this.share,
  });

  PrivateKeyInfo.fromReader(BytesReader reader) : this(
    identifier: Identifier.fromBytes(reader.readSlice(32)),
    share: ECPrivateKey(reader.readSlice(32)),
  );

  @override
  void write(Writer writer) {
    writer.writeSlice(identifier.toBytes());
    writer.writeSlice(share.data);
  }

}
