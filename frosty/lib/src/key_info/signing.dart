import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'key_info.dart';
import 'group.dart';
import 'private.dart';

/// Contains details required specifically for providing a signature share. This
/// contains the [GroupKeyInfo] and [PrivateKeyInfo] but excludes the
/// public shares which aren't needed.
class SigningKeyInfo extends KeyInfo {

  final GroupKeyInfo group;
  final PrivateKeyInfo private;

  SigningKeyInfo({
    required this.group,
    required this.private,
  });

  SigningKeyInfo.fromReader(BytesReader reader) : this(
    group: GroupKeyInfo.fromReader(reader),
    private: PrivateKeyInfo.fromReader(reader),
  );

  /// Convenience constructor to construct from serialised [bytes].
  SigningKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  SigningKeyInfo.fromHex(String hex) : this.fromBytes(hexToBytes(hex));

  @override
  void write(Writer writer) {
    group.write(writer);
    private.write(writer);
  }

  @override
  /// Tweaks the signing key info by a scalar. null may be returned if the
  /// scalar was crafted to lead to an invalid key or private share.
  SigningKeyInfo? tweak(Uint8List scalar) {
    final newGroup = group.tweak(scalar);
    final newPrivate = private.tweak(scalar);
    return newGroup == null || newPrivate == null
      ? null
      : SigningKeyInfo(group: newGroup, private: newPrivate);
  }

}
