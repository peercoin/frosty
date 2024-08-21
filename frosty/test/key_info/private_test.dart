import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "0000000000000000000000000000000000000000000000000000000000000001"
  "${privateSharesHex[0]}";

final tweakedHex
  = "0000000000000000000000000000000000000000000000000000000000000001"
  "${tweakedPrivateShareHex[0]}";

void main() {
  group("PrivateKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidShareTweak,
      fromHex: (hex) => PrivateKeyInfo.fromHex(hex),
      getValidObj: () => getParticipantInfo(0).private,
    );

  });
}
