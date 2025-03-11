import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/key_info/signing.dart';
import 'derivable.dart';
import 'hd_key_info.dart';

class HDSigningKeyInfo extends SigningKeyInfo implements HDDerivableInfo {

  @override
  final HDKeyInfo hdInfo;

  HDSigningKeyInfo({
    required super.group,
    required super.private,
    required this.hdInfo,
  });

  HDSigningKeyInfo.master({
    required super.group,
    required super.private,
  }) : hdInfo = HDKeyInfo.master;

  HDSigningKeyInfo.fromReader(super.reader)
    : hdInfo = HDKeyInfo.fromReader(reader), super.fromReader();

  /// Convenience constructor to construct from serialised [bytes].
  HDSigningKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  HDSigningKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    hdInfo.write(writer);
    super.write(writer);
  }

  @override
  HDSigningKeyInfo derive(int index) {
    final (tweak, newHdInfo) = hdInfo.deriveTweakAndInfo(groupKey, index);
    return HDSigningKeyInfo(
      group: group.tweak(tweak)!,
      private: private.tweak(tweak)!,
      hdInfo: newHdInfo,
    );
  }

}
