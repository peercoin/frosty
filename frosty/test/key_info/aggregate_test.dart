import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "027f2b9f6b67de76a624c750226221a73f79280d91f3e14b42e0994950605804b2020003000000000000000000000000000000000000000000000000000000000000000001030251582b6921a9aba190a761740a8b07f2d1e11aa66ce2f2b039d387f802ba8b000000000000000000000000000000000000000000000000000000000000000203fa55e35e8390e0b636b766d1db0b89f436b65889cd04dd039052655ed810c9a300000000000000000000000000000000000000000000000000000000000000030355a1a070b2d0d2c47e37854e969e8817151597e0d37d0b7ebb21026fb09c90bc";

void main() {
  group("AggregateKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      name: "aggregate",
      validHex: validHex,
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
