import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "${groupPublicKeyHex}0200"
  "03000000000000000000000000000000000000000000000000000000000000000001"
  "${publicShareKeyHex[0]}"
  "0000000000000000000000000000000000000000000000000000000000000002"
  "${publicShareKeyHex[1]}"
  "0000000000000000000000000000000000000000000000000000000000000003"
  "${publicShareKeyHex[2]}";

final tweakedHex
  = "${tweakedGroupKeyHex}0200"
  "03000000000000000000000000000000000000000000000000000000000000000001"
  "${tweakedPublicShareKeyHex[0]}"
  "0000000000000000000000000000000000000000000000000000000000000002"
  "${tweakedPublicShareKeyHex[1]}"
  "0000000000000000000000000000000000000000000000000000000000000003"
  "${tweakedPublicShareKeyHex[2]}";

void main() {
  group("AggregateKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromReader: (reader) => AggregateKeyInfo.fromReader(reader),
      // Test getting from ParticipantKeyInfo
      getValidObj: () => getParticipantInfo(0).aggregate,
    );

    test("invalid aggregate info arguments", () {

      // Invalid threshold
      expect(
        () => AggregateKeyInfo(
          group: GroupKeyInfo(
            publicKey: groupPublicKey,
            threshold: 4,
          ),
          publicShares: publicSharesInfo,
        ), throwsA(isA<InvalidKeyInfo>()),
      );

    });

  });
}
