import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "${groupPublicKeyHex}0200"
  "0000000000000000000000000000000000000000000000000000000000000001"
  "${privateSharesHex[0]}";

final tweakedHex
  = "${tweakedGroupKeyHex}0200"
  "0000000000000000000000000000000000000000000000000000000000000001"
  "${tweakedPrivateShareHex[0]}";

void main() {
  group("SigningKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidShareTweak,
      fromReader: (reader) => SigningKeyInfo.fromReader(reader),
      // Test getting from ParticipantKeyInfo
      getValidObj: () => getParticipantInfo(0).signing,
    );

  });
}
