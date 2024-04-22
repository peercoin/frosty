import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/key_info/aggregate.dart';
import 'derivable.dart';
import 'hd_key_info.dart';

class HDAggregateKeyInfo extends AggregateKeyInfo implements HDDerivableInfo {

  @override
  final HDKeyInfo hdInfo;

  HDAggregateKeyInfo({
    required super.group,
    required super.publicShares,
    required this.hdInfo,
  });

  HDAggregateKeyInfo.fromReader(super.reader)
    : hdInfo = HDKeyInfo.fromReader(reader), super.fromReader();

  HDAggregateKeyInfo.master({
    required super.group,
    required super.publicShares,
  }) : hdInfo = HDKeyInfo.master;

  @override
  void write(Writer writer) {
    hdInfo.write(writer);
    super.write(writer);
  }

  @override
  HDAggregateKeyInfo derive(int index) {
    final (tweak, newHdInfo) = hdInfo.deriveTweakAndInfo(group.publicKey, index);
    return HDAggregateKeyInfo(
      group: group.tweak(tweak)!,
      publicShares: publicShares.tweak(tweak)!,
      hdInfo: newHdInfo,
    );
  }

}
