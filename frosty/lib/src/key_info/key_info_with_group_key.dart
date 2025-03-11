import 'package:coinlib/coinlib.dart' as cl;
import 'key_info.dart';

abstract class KeyInfoWithGroupKey
  extends KeyInfo
  implements Comparable<KeyInfoWithGroupKey> {

  cl.ECCompressedPublicKey get groupKey;

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is KeyInfoWithGroupKey && groupKey == other.groupKey
  );

  @override
  int get hashCode => groupKey.hashCode;

  @override
  int compareTo(KeyInfoWithGroupKey other) => cl.compareBytes(
    groupKey.data, other.groupKey.data,
  );

}
