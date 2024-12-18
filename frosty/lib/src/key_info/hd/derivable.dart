import 'hd_key_info.dart';

abstract interface class HDDerivableInfo {
  HDKeyInfo get hdInfo;
  /// Derive child key information using unhardened BIP32 derivation. Hardened
  /// derivation is not possible.
  HDDerivableInfo derive(int index);
}
