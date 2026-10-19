import 'dart:typed_data';

import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

void main() {
  group("DkgPart1", () {
    late Identifier id;
    setUpAll(() async {
      await loadFrosty();
      id = Identifier.fromUint16(1);
    });

    test("is different each time", () {
      expect(
        DkgPart1(identifier: id, threshold: 2, n: 3).public.toBytes(),
        isNot(DkgPart1(identifier: id, threshold: 2, n: 3).public.toBytes()),
      );
    });

    test("commitment scales with threshold", () {
      int getLen(int t, int n) =>
          DkgPart1(identifier: id, threshold: t, n: n).public.toBytes().length;

      final t1Len = getLen(2, 2);
      final t2Len = getLen(3, 5);
      final t3Len = getLen(4, 4);

      expect(t1Len, lessThan(t2Len));
      expect(t2Len, lessThan(t3Len));
    });

    test("secret round trips and remains usable", () {
      final parts = List.generate(
        3,
        (i) => DkgPart1(
          identifier: Identifier.fromUint16(i + 1),
          threshold: 2,
          n: 3,
        ),
      );
      final bytes = parts.first.secret.toBytes();
      final restored = DkgRound1Secret.fromBytes(bytes);
      parts.first.secret.dispose();
      final commitments = DkgCommitmentSet([
        for (var i = 0; i < parts.length; i++)
          (Identifier.fromUint16(i + 1), parts[i].public),
      ]);

      expect(
        DkgPart2(
          identifier: id,
          round1Secret: restored,
          commitments: commitments,
        ).sharesToGive,
        hasLength(2),
      );
      for (final invalid in [
        Uint8List(0),
        Uint8List.sublistView(bytes, 1),
        Uint8List.fromList([...bytes, 0]),
      ]) {
        expect(
          () => DkgRound1Secret.fromBytes(invalid),
          throwsA(isA<InvalidDkgRound1Secret>()),
        );
      }
    });

    test("invalid round 1", () {
      void expectError(int threshold, int n) => expect(
        () => DkgPart1(identifier: id, threshold: threshold, n: n),
        throwsArgumentError,
      );
      expectError(1, 2);
      expectError(1, 1);
      expectError(2, 0x10000);
      expectError(3, 2);
    });

    test("secret buffers can be cleared without corrupting later exports", () {
      final secret = DkgPart1(identifier: id, threshold: 2, n: 3).secret;
      final bytes = secret.toBytes();
      final expected = Uint8List.fromList(bytes);
      final restored = DkgRound1Secret.fromBytes(bytes);

      bytes.fillRange(0, bytes.length, 0);
      expect(secret.toBytes(), expected);
      expect(restored.toBytes(), expected);

      final exported = restored.toBytes();
      exported.fillRange(0, exported.length, 0);
      expect(restored.toBytes(), expected);

      secret.dispose();
      restored.dispose();
      expect(() => secret.toBytes(), throwsA(isA<UseAfterFree>()));
      expect(() => restored.toBytes(), throwsA(isA<UseAfterFree>()));
    });
  });
}
