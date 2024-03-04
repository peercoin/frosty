import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import "../data.dart";

void main() {
  group("SignPart1", () {

    setUp(() async {
      await loadFrosty();
    });

    test("is different each time", () {
      expect(
        SignPart1(privateShare: privateShares.first).commitment.toBytes(),
        isNot(SignPart1(privateShare: privateShares.first).commitment.toBytes()),
      );
    });

  });
}
