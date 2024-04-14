import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "027f2b9f6b67de76a624c750226221a73f79280d91f3e14b42e0994950605804b20200";

void main() {
  group("GroupKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      name: "group",
      validHex: validHex,
      fromReader: (reader) => GroupKeyInfo.fromReader(reader),
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

      // Uncompressed public key
      expect(
        () => GroupKeyInfo(
          publicKey: uncompressedPk,
          threshold: 2,
        ), throwsA(isA<InvalidKeyInfo>()),
      );

    });

  });
}
