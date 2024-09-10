import 'dart:typed_data';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

void main() {
  group("SignDetails", () {

    test("succeeds", () {

      final scriptSpend = SignDetails.scriptSpend(message: Uint8List(32));
      expect(scriptSpend.message, Uint8List(32));
      expect(scriptSpend.mastHash, null);

      final withMast = SignDetails.keySpend(
        message: Uint8List(32),
        mastHash: Uint8List(32)..last = 1,
      );
      expect(withMast.message, Uint8List(32));
      expect(withMast.mastHash, Uint8List(32)..last = 1);

      final emptyMast = SignDetails.keySpend(
        message: Uint8List(32),
      );
      expect(emptyMast.message, Uint8List(32));
      expect(emptyMast.mastHash, Uint8List(0));

    });

    test("fails", () {
      void expectFail(Uint8List msg, Uint8List? mast) => expect(
        () => SignDetails(message: msg, mastHash: mast),
        throwsA(isA<InvalidSignDetails>()),
      );
      expectFail(Uint8List(31), null);
      expectFail(Uint8List(33), null);
      expectFail(Uint8List(32), Uint8List(31));
      expectFail(Uint8List(32), Uint8List(33));
    });

    final il32 = Uint8List(32);

    test("fromBytes valid", () {

      void expectDetails(List<int> bytes, Uint8List? mast) {
        final uintList = Uint8List.fromList(bytes);
        final obj = SignDetails.fromBytes(uintList);
        expect(obj.toBytes(), uintList);
        expect(obj.mastHash, mast);
      }

      expectDetails([...il32, 0], null);
      expectDetails([...il32, 1], Uint8List(0));
      expectDetails([...il32, 2, ...il32], Uint8List(32));

    });

    test("fromBytes invalid", () {
      for (final bytes in [
        [0], [...il32], [...il32, 2], [...il32, 3, ...il32],
      ]) {
        expect(
          () => SignDetails.fromBytes(Uint8List.fromList(bytes)),
          throwsException,
        );
      }
    });

  });
}
