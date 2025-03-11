import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/identifier.dart';
import 'key_info.dart';

/// Contains the private share required for a participant to submit signature
/// shares for a FROST key.
class PrivateKeyInfo extends KeyInfo {

  /// The identifier of the participant who owns the [share].
  final Identifier identifier;
  /// The key share owned by the participant which must remain confidential.
  final cl.ECPrivateKey share;

  /// Provides the private key share and participant identifier. The identifier
  /// and private share are assumed to belong to a public share in the FROST
  /// key.
  PrivateKeyInfo({
    required this.identifier,
    required this.share,
  });

  PrivateKeyInfo.fromReader(cl.BytesReader reader) : this(
    identifier: Identifier.fromBytes(reader.readSlice(32)),
    share: cl.ECPrivateKey(reader.readSlice(32)),
  );

  /// Convenience constructor to construct from serialised [bytes].
  PrivateKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  PrivateKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    writer.writeSlice(identifier.toBytes());
    writer.writeSlice(share.data);
  }

  @override
  /// Tweaks the private key share by a scalar. null may be returned if the
  /// scalar was crafted to lead to an invalid private key share.
  PrivateKeyInfo? tweak(Uint8List scalar) {
    final newShare = share.tweak(scalar);
    return newShare == null ? null : PrivateKeyInfo(
      identifier: identifier,
      share: newShare,
    );
  }

}
