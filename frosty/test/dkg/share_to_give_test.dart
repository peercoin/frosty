import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

void main() {
  group("DkgShareToGive", () {

    setUp(loadFrosty);

    final validBytes = hexToBytes(
      "a3ee9514c0c431a4fc8eb815f2e472d389e60c86692398a7ff9e20d57a33a6cef49d8cce",
    );

    test("fromBytes valid", () {
      expect(
        DkgShareToGive.fromBytes(validBytes).toBytes(),
        validBytes,
      );
    });

    test("fromBytes invalid", () {
      void expectInvalid(Uint8List bytes) => expect(
        () => DkgShareToGive.fromBytes(bytes),
        throwsA(isA<InvalidShareToGive>()),
      );
      expectInvalid(Uint8List(0));
      expectInvalid(Uint8List.view(validBytes.buffer, 1));
      expectInvalid(Uint8List.fromList([...validBytes, 0]));
    });

    test("cannot use after free", () {
      final secret = DkgShareToGive.fromBytes(validBytes);
      secret.dispose();
      expect(() => secret.toBytes(), throwsA(isA<UseAfterFree>()));
    });

  });
}
