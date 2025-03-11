import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/key_info/group.dart';
import 'derivable.dart';
import 'hd_key_info.dart';

class HDGroupKeyInfo extends GroupKeyInfo implements HDDerivableInfo {

  @override
  final HDKeyInfo hdInfo;

  HDGroupKeyInfo({
    required super.groupKey,
    required super.threshold,
    required this.hdInfo,
  });

  HDGroupKeyInfo.master({
    required super.groupKey,
    required super.threshold,
  }) : hdInfo = HDKeyInfo.master;

  HDGroupKeyInfo.fromReader(super.reader)
    : hdInfo = HDKeyInfo.fromReader(reader), super.fromReader();

  /// Convenience constructor to construct from serialised [bytes].
  HDGroupKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  HDGroupKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    hdInfo.write(writer);
    super.write(writer);
  }

  @override
  HDGroupKeyInfo derive(int index) {
    final (tweak, newHdInfo) = hdInfo.deriveTweakAndInfo(groupKey, index);
    return HDGroupKeyInfo(
      groupKey: groupKey.tweak(tweak)!,
      threshold: threshold,
      hdInfo: newHdInfo,
    );
  }

}
