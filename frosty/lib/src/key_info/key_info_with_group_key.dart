import 'package:coinlib/coinlib.dart';
import 'key_info.dart';

abstract class KeyInfoWithGroupKey
  extends KeyInfo
  implements Comparable<KeyInfoWithGroupKey> {

  ECCompressedPublicKey get groupKey;

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is KeyInfoWithGroupKey && groupKey == other.groupKey
  );

  @override
  int get hashCode => groupKey.hashCode;

  @override
  int compareTo(KeyInfoWithGroupKey other) => compareBytes(
    groupKey.data, other.groupKey.data,
  );

}
