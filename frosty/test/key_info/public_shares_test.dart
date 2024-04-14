import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "03000000000000000000000000000000000000000000000000000000000000000001030251582b6921a9aba190a761740a8b07f2d1e11aa66ce2f2b039d387f802ba8b000000000000000000000000000000000000000000000000000000000000000203fa55e35e8390e0b636b766d1db0b89f436b65889cd04dd039052655ed810c9a300000000000000000000000000000000000000000000000000000000000000030355a1a070b2d0d2c47e37854e969e8817151597e0d37d0b7ebb21026fb09c90bc";

void main() {
  group("PublicSharesKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      name: "public",
      validHex: validHex,
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
