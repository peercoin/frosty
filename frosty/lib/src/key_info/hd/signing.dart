import 'package:coinlib/coinlib.dart';
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

  @override
  void write(Writer writer) {
    hdInfo.write(writer);
    super.write(writer);
  }

  @override
  HDSigningKeyInfo derive(int index) {
    final (tweak, newHdInfo) = hdInfo.deriveTweakAndInfo(group.publicKey, index);
    return HDSigningKeyInfo(
      group: group.tweak(tweak)!,
      private: private.tweak(tweak)!,
      hdInfo: newHdInfo,
    );
  }

}
