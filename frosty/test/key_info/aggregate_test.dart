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

final info = AggregateKeyInfo.fromHex(validHex);

void main() {
  group("AggregateKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromHex: (hex) => AggregateKeyInfo.fromHex(hex),
      // Test getting from ParticipantKeyInfo
      getValidObj: () => getParticipantInfo(0).aggregate,
    );

    test("invalid aggregate info arguments", () {

      // Invalid threshold
      expect(
        () => AggregateKeyInfo(
          group: GroupKeyInfo(
            groupKey: groupPublicKey,
            threshold: 4,
          ),
          publicShares: publicSharesInfo,
        ), throwsA(isA<InvalidKeyInfo>()),
      );

    });

    test("can add unique group keys into set", () {

      final s = {
        for (final hex in [validHex, tweakedHex, validHex, tweakedHex])
          AggregateKeyInfo.fromHex(hex),
      };

      expect(
        s.map((s) => s.toHex()).toList(),
        unorderedEquals([validHex, tweakedHex]),
      );

    });

    test("invalid private key construct", () {

      void expectSharesThrow<Err>(PrivateShareList shares) => expect(
        () => info.constructPrivateKey(shares),
        throwsA(isA<Err>()),
      );

      // Not enough shares
      expectSharesThrow<ArgumentError>([(ids[0], privateShares[0])]);
      // Too many
      expectSharesThrow<ArgumentError>(
        [for (var i = 0; i < 3; i++) (ids[i], privateShares[i]),],
      );
      // Wrong shares
      expectSharesThrow<InvalidShares>(
        [for (var i = 0; i < 2; i++) (ids[i+1], privateShares[i]),],
      );

    });

    test(
      "can construct private key",
      () => expect(
        info.constructPrivateKey([
          (ids[0], privateShares[0]),
          (ids[1], privateShares[1]),
        ]).pubkey,
        groupPublicKey,
      ),
    );

  });
}
