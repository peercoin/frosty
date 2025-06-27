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

final info = ParticipantKeyInfo.fromHex(validHex);

void main() {
  group("ParticipantKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromHex: (hex) => ParticipantKeyInfo.fromHex(hex),
      getValidObj: () => getParticipantInfo(0),
    );

    test("invalid participant info arguments", () {

      // Invalid threshold
      expect(
        () => ParticipantKeyInfo(
          group: GroupKeyInfo(
            groupKey: groupPublicKey,
            threshold: 4,
          ),
          publicShares: publicSharesInfo,
          private: getParticipantInfo(0).private,
        ), throwsA(isA<InvalidKeyInfo>()),
      );

    });

    test("invalid private key construct", () {

      void expectSharesThrow<Err>(PrivateShareList shares) => expect(
        () => info.constructPrivateKey(shares),
        throwsA(isA<Err>()),
      );

      // Not enough shares
      expectSharesThrow<ArgumentError>(PrivateShareList.empty());
      // Too many
      expectSharesThrow<ArgumentError>(
        [for (var i = 0; i < 2; i++) (ids[i], privateShares[i]),],
      );
      // Wrong shares
      expectSharesThrow<InvalidShares>(
        [(ids[2], privateShares[1])],
      );

    });

    test(
      "can construct private key",
      () => expect(
        info.constructPrivateKey([(ids[1], privateShares[1])]).pubkey,
        groupPublicKey,
      ),
    );

  });
}
