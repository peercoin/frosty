import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

void main() {
  group("DkgRound1", () {

    late Identifier id;
    setUp(() async {
      await loadFrosty();
      id = Identifier.fromUint16(1);
    });

    test("is different each time", () {
      expect(
        DkgRound1(identifier: id, threshold: 2, n: 3).public.toBytes(),
        isNot(DkgRound1(identifier: id, threshold: 2, n: 3).public.toBytes()),
      );
    });

    test("commitment scales with threshold", () {

      int getLen(int t, int n) => DkgRound1(
        identifier: id, threshold: t, n: n,
      ).public.toBytes().length;

      final t1Len = getLen(2, 2);
      final t2Len = getLen(3, 5);
      final t3Len = getLen(4, 4);

      expect(t1Len, lessThan(t2Len));
      expect(t2Len, lessThan(t3Len));

    });

    test("invalid round 1", () {
      void expectError(int threshold, int n) => expect(
        () => DkgRound1(identifier: id, threshold: threshold, n: n),
        throwsArgumentError,
      );
      expectError(1, 2);
      expectError(1, 1);
      expectError(2, 0x10000);
      expectError(3, 2);
    });

  });
}
