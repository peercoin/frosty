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
  "${publicShareKeyHex[2]}"
  "0000000000000000000000000000000000000000000000000000000000000001"
  "${privateSharesHex[0]}";

final tweakedHex
  = "${tweakedGroupKeyHex}0200"
  "03000000000000000000000000000000000000000000000000000000000000000001"
  "${tweakedPublicShareKeyHex[0]}"
  "0000000000000000000000000000000000000000000000000000000000000002"
  "${tweakedPublicShareKeyHex[1]}"
  "0000000000000000000000000000000000000000000000000000000000000003"
  "${tweakedPublicShareKeyHex[2]}"
  "0000000000000000000000000000000000000000000000000000000000000001"
  "${tweakedPrivateShareHex[0]}";

void main() {
  group("ParticipantKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromReader: (reader) => ParticipantKeyInfo.fromReader(reader),
      getValidObj: () => getParticipantInfo(0),
    );

    test("invalid participant info arguments", () {

      // Invalid threshold
      expect(
        () => ParticipantKeyInfo(
          group: GroupKeyInfo(
            publicKey: groupPublicKey,
            threshold: 4,
          ),
          publicShares: publicSharesInfo,
          private: getParticipantInfo(0).private,
        ), throwsA(isA<InvalidKeyInfo>()),
      );

    });

  });
}
