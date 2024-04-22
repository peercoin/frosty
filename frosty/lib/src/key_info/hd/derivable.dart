import 'package:frosty/src/key_info/key_info.dart';
import 'hd_key_info.dart';

abstract interface class HDDerivableInfo {
  HDKeyInfo get hdInfo;
  /// Derive child key information using unhardened BIP32 derivation. Hardened
  /// derivation is not possible.
  KeyInfo derive(int index);
}
