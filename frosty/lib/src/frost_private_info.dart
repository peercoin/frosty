import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/identifier.dart';
import 'frost_public_info.dart';

/// Contains the information required for a participant to submit signature
/// shares for a FROST key. This includes the [public] info alongside the
/// participant's [privateShare].
class FrostPrivateInfo with Writable {

  /// The identifier of the participant who owns the [privateShare].
  final Identifier identifier;
  /// The key share owned by the participant which must remain confidential.
  final ECPrivateKey privateShare;
  /// The public information for the FROST key.
  final FrostPublicInfo public;

  /// Provides the private key share alongside public information for the FROST
  /// key. The identifier and private share are assumed to belong to the public
  /// shares.
  FrostPrivateInfo({
    required this.identifier,
    required this.privateShare,
    required this.public,
  });

  FrostPrivateInfo.fromReader(BytesReader reader) : this(
    identifier: Identifier.fromBytes(reader.readSlice(32)),
    privateShare: ECPrivateKey(reader.readSlice(32)),
    public: FrostPublicInfo.fromReader(reader),
  );

  @override
  void write(Writer writer) {
    writer.writeSlice(identifier.toBytes());
    writer.writeSlice(privateShare.data);
    public.write(writer);
  }

}
