import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex = "${groupPublicKeyHex}0200";
final tweakedHex = "${tweakedGroupKeyHex}0200";

void main() {
  group("GroupKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromHex: (hex) => GroupKeyInfo.fromHex(hex),
      getValidObj: () => groupInfo,
    );

    test("invalid group info arguments", () {
      // Invalid threshold
      expect(
        () => GroupKeyInfo(
          publicKey: groupPublicKey,
          threshold: 1,
        ), throwsA(isA<InvalidKeyInfo>()),
      );
    });

  });
}
