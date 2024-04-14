import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:test/test.dart';

void basicInfoTests<T extends Writable>({
  required String name,
  required String validHex,
  required T Function(BytesReader reader) fromReader,
  required T Function() getValidObj,
}) {

    test("valid $name info", () {
      expect(getValidObj().toHex(), validHex);
      expect(
        fromReader(BytesReader(hexToBytes(validHex))).toHex(),
        validHex,
      );
    });

    test("invalid $name info bytes", () => expect(
        () => fromReader(BytesReader(Uint8List(0))),
        throwsA(isA<OutOfData>()),
    ),);

}
