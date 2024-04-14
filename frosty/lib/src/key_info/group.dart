import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/key_info/invalid_info.dart';

/// Contains information of a FROST key required for all participants and the
/// coordinator. This includes the group public key and the threshold number.
class GroupKeyInfo with Writable {

  /// The public key of the overall FROST key
  final ECPublicKey publicKey;
  /// The number of signers required for a signature
  final int threshold;

  /// Takes the FROST key information. If this information is invalid
  /// [InvalidKeyInfo] may be thrown.
  GroupKeyInfo({
    required this.publicKey,
    required this.threshold,
  }) {

    if (threshold < 2) throw InvalidKeyInfo("threshold should at least 2");

    if (!publicKey.compressed) {
      throw InvalidKeyInfo(
        "GroupKeyInfo cannot accept an uncompressed group key",
      );
    }

  }

  GroupKeyInfo.fromReader(BytesReader reader) : this(
    publicKey: ECPublicKey(reader.readSlice(33)),
    threshold: reader.readUInt16(),
  );

  @override
  void write(Writer writer) {
    writer.writeSlice(publicKey.data);
    writer.writeUInt16(threshold);
  }

}
