import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/key_info/group.dart';
import 'derivable.dart';
import 'hd_key_info.dart';

class HDGroupKeyInfo extends GroupKeyInfo implements HDDerivableInfo {

  @override
  final HDKeyInfo hdInfo;

  HDGroupKeyInfo({
    required super.publicKey,
    required super.threshold,
    required this.hdInfo,
  });

  HDGroupKeyInfo.master({
    required super.publicKey,
    required super.threshold,
  }) : hdInfo = HDKeyInfo.master;

  HDGroupKeyInfo.fromReader(super.reader)
    : hdInfo = HDKeyInfo.fromReader(reader), super.fromReader();

  @override
  void write(Writer writer) {
    hdInfo.write(writer);
    super.write(writer);
  }

  @override
  HDGroupKeyInfo derive(int index) {
    final (tweak, newHdInfo) = hdInfo.deriveTweakAndInfo(publicKey, index);
    return HDGroupKeyInfo(
      publicKey: publicKey.tweak(tweak)!,
      threshold: threshold,
      hdInfo: newHdInfo,
    );
  }

}
