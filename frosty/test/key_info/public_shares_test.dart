import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "03000000000000000000000000000000000000000000000000000000000000000001"
  "${publicShareKeyHex[0]}"
  "0000000000000000000000000000000000000000000000000000000000000002"
  "${publicShareKeyHex[1]}"
  "0000000000000000000000000000000000000000000000000000000000000003"
  "${publicShareKeyHex[2]}";

final tweakedHex
  = "03000000000000000000000000000000000000000000000000000000000000000001"
  "${tweakedPublicShareKeyHex[0]}"
  "0000000000000000000000000000000000000000000000000000000000000002"
  "${tweakedPublicShareKeyHex[1]}"
  "0000000000000000000000000000000000000000000000000000000000000003"
  "${tweakedPublicShareKeyHex[2]}";

void main() {
  group("PublicSharesKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidShareTweak,
      fromReader: (reader) => PublicSharesKeyInfo.fromReader(reader),
      getValidObj: () => publicSharesInfo,
    );

    test("invalid public shares info arguments", () {

      // Uncompressed public key
      expect(
        () => PublicSharesKeyInfo(
          publicShares: [
            publicShares[0],
            publicShares[1],
            (publicShares[2].$1, uncompressedPk),
          ],
        ), throwsA(isA<InvalidKeyInfo>()),
      );

      // Duplicate Identifier
      expect(
        () => PublicSharesKeyInfo(
          publicShares: [
            publicShares[0],
            (publicShares[1].$1, publicShares[1].$2),
            (publicShares[1].$1, publicShares[2].$2),
          ],
        ), throwsA(isA<InvalidKeyInfo>()),
      );

    });

  });
}
