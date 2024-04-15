import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

final tweak = hexToBytes(
  "2bfe58ab6d9fd575bdc3a624e4825dd2b375d64ac033fbc46ea79dbab4f69a3e",
);

void basicInfoTests<T extends KeyInfo>({
  required String validHex,
  required String tweakedHex,
  required String invalidTweakHex,
  required T Function(BytesReader reader) fromReader,
  required T Function() getValidObj,
}) {

    test("valid info", () {
      expect(getValidObj().toHex(), validHex);
      expect(
        fromReader(BytesReader(hexToBytes(validHex))).toHex(),
        validHex,
      );
    });

    test("tweaks as expected", () {
      expect(getValidObj().tweak(tweak)!.toHex(), tweakedHex);
      expect(getValidObj().tweak(Uint8List(32))!.toHex(), validHex);
    });

    test(
      "invalid tweak",
      () => expect(getValidObj().tweak(hexToBytes(invalidTweakHex)), null),
    );

    test("invalid info bytes", () => expect(
        () => fromReader(BytesReader(Uint8List(0))),
        throwsA(isA<OutOfData>()),
    ),);

}
