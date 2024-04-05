import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgPart2", () {

    late List<Identifier> ids;
    late List<DkgPart1> eachPart1;
    late List<DkgCommitmentSet> eachCommitmentSet;
    setUp(() async {
      await loadFrosty();
      (ids, eachPart1, eachCommitmentSet) = genPart1();
    });

    test("gives expected secrets to share", () {

      for (int i = 0; i < 3; i++) {
        final part2 = DkgPart2(
          round1Secret: eachPart1[i].secret,
          commitments: eachCommitmentSet[i],
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
          round1Secret: eachPart1.first.secret,
          commitments: eachCommitmentSet.first,
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

      // Invalid proof of knowledge by giving the third commitment to the second
      expect(
        () => DkgPart2(
          round1Secret: eachPart1[0].secret,
          commitments: DkgCommitmentSet([
            (ids[1], eachPart1[2].public),
            (ids[2], eachPart1[2].public),
          ]),
        ),
        throwsA(
          isA<InvalidPart2ProofOfKnowledge>()
          .having((err) => err.culprit, "culprit", Identifier.fromUint16(2)),
        ),
      );

    });

  });
}
