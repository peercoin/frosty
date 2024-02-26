import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

void main() {
  group("DkgPart2", () {

    late List<Identifier> ids;
    late List<DkgPart1> eachPart1;
    setUp(() async {
      await loadFrosty();
      ids = List.generate(3, (i) => Identifier.fromUint16(1+i));
      eachPart1 = List.generate(
        3,
        (i) => DkgPart1(
          identifier: ids[i],
          threshold: 2,
          n: 3,
        ),
      );
    });

    test("gives expected secrets to share", () {

      for (int i = 0; i < 3; i++) {
        final part2 = DkgPart2(
          round1Secret: eachPart1[i].secret,
          commitments: DkgCommitmentSet([
            for (int j = 0; j < 3; j++)
              if (j != i) (ids[j], eachPart1[j].public),
          ]),
        );
        expect(part2.sharesToGive.length, 2);
        // Should have other identifiers
        expect(
          part2.sharesToGive.map((sts) => sts.$1).toList(),
          unorderedEquals(
            [for (final id in ids) if (id != ids[i]) id],
          ),
        );
      }

    });

    void expectUseAfterFree() {
      expect(
        () => DkgPart2(
          round1Secret: eachPart1[0].secret,
          commitments: DkgCommitmentSet([
            for (int j = 1; j < 3; j++) (ids[j], eachPart1[j].public),
          ]),
        ),
        throwsA(isA<UseAfterFree>()),
      );
    }

    test("cannot use round 1 secret after free", () {
      eachPart1[0].secret.dispose();
      expectUseAfterFree();
    });

    test("cannot use public commitment after free", () {
      eachPart1[1].public.dispose();
      expectUseAfterFree();
    });

    test("invalid round 2", () {

      // Wrong amount of commitments
      expect(
        () => DkgPart2(
          round1Secret: eachPart1[0].secret,
          commitments: DkgCommitmentSet([(ids[1], eachPart1[1].public)]),
        ),
        throwsA(isA<InvalidPart2>()),
      );

      // Invalid proof of knowledge by swapping them around
      expect(
        () => DkgPart2(
          round1Secret: eachPart1[0].secret,
          commitments: DkgCommitmentSet([
            for (int j = 1; j < 3; j++) (ids[j], eachPart1[3-j].public),
          ]),
        ),
        throwsA(isA<InvalidPart2>()),
      );

    });

  });
}
