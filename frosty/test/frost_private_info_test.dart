import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import 'data.dart';

final validHex =
"0000000000000000000000000000000000000000000000000000000000000001bafe4fab41fee3ca118cce1af9c2432189030d0e0249365787b8e71da37fdbb3027f2b9f6b67de76a624c750226221a73f79280d91f3e14b42e0994950605804b203000000000000000000000000000000000000000000000000000000000000000001030251582b6921a9aba190a761740a8b07f2d1e11aa66ce2f2b039d387f802ba8b000000000000000000000000000000000000000000000000000000000000000203fa55e35e8390e0b636b766d1db0b89f436b65889cd04dd039052655ed810c9a300000000000000000000000000000000000000000000000000000000000000030355a1a070b2d0d2c47e37854e969e8817151597e0d37d0b7ebb21026fb09c90bc0200";

void main() {
  group("FrostPrivateInfo", () {

    setUp(loadFrosty);

    test("valid private info", () {

      final valid = FrostPrivateInfo(
        identifier: Identifier.fromUint16(1),
        privateShare: privateShares.first,
        public: FrostPublicInfo(
          groupPublicKey: groupPublicKey,
          publicShares: publicShares,
          threshold: 2,
        ),
      );

      expect(valid.toHex(), validHex);
      expect(
        FrostPrivateInfo.fromReader(BytesReader(hexToBytes(validHex))).toHex(),
        validHex,
      );

    });

    test("invalid private info bytes", () {

      void expectThrows<T>(Uint8List invalid) => expect(
        () => FrostPrivateInfo.fromReader(BytesReader(invalid)),
        throwsA(isA<T>()),
      );

      expectThrows<OutOfData>(Uint8List(0));
      expectThrows<InvalidPublicInfo>(hexToBytes(validHex)..last = 0xff);

    });

  });
}
