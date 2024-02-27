import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  group("DkgPart3", () {

    late List<Identifier> ids;
    late List<DkgPart1> eachPart1;
    late List<DkgCommitmentSet> eachCommitmentSet;
    late List<DkgPart2> eachPart2;
    late List<List<(Identifier, DkgShareToGive)>> eachReceivedShares;

    setUp(() async {

      await loadFrosty();
      (ids, eachPart1, eachCommitmentSet) = genPart1();

      eachPart2 = List.generate(
        3,
        (i) => DkgPart2(
          round1Secret: eachPart1[i].secret,
          commitments: eachCommitmentSet[i],
        ),
      );

      eachReceivedShares = List.generate(
        3, (i) => [
          for (int j = 0; j < 3; j++)
            if (j != i) (
              ids[j],
              eachPart2[j].sharesToGive
              .firstWhere((e) => e.$1 == ids[i])
              .$2,
            ),
        ],
      );

    });

    test("gives different key shares to participants", () {

      final eachPart3 = List.generate(
        3, (i) => DkgPart3(
          round2Secret: eachPart2[i].secret,
          commitments: eachCommitmentSet[i],
          receivedShares: eachReceivedShares[i],
        ),
      );

      // TODO: Check unique key share and identical public shares

    });

    void expectUseAfterFree() {
      expect(
        () => DkgPart3(
          round2Secret: eachPart2.first.secret,
          commitments: eachCommitmentSet.first,
          receivedShares: eachReceivedShares.first,
        ),
        throwsA(isA<UseAfterFree>()),
      );
    }

    test("cannot use round 2 secret after free", () {
      eachPart2[0].secret.dispose();
      expectUseAfterFree();
    });

    test("cannot use public commitment after free", () {
      eachCommitmentSet[0].list[0].$2.dispose();
      expectUseAfterFree();
    });

    test("cannot use received share after free", () {
      eachReceivedShares[0][0].$2.dispose();
      expectUseAfterFree();
    });

    test("invalid round 3", () {

      // Wrong amount of commitments
      expect(
        () => DkgPart3(
          round2Secret: eachPart2.first.secret,
          commitments: DkgCommitmentSet([(ids[1], eachPart1[1].public)]),
          receivedShares: eachReceivedShares.first,
        ),
        throwsA(isA<InvalidPart3>()),
      );

      // Wrong amont of shares
      expect(
        () => DkgPart3(
          round2Secret: eachPart2.first.secret,
          commitments: eachCommitmentSet.first,
          receivedShares: eachReceivedShares.first.sublist(1),
        ),
        throwsA(isA<InvalidPart3>()),
      );

      // Invalid shares.
      expect(
        () => DkgPart3(
          round2Secret: eachPart2.first.secret,
          commitments: eachCommitmentSet.first,
          receivedShares: [
            for (int i = 0; i < 2; i++) (
              // Incorrect ID for share
              ids[2-i],
              eachReceivedShares.first[i].$2,
            ),
          ],
        ),
        throwsA(isA<InvalidPart3>()),
      );

    });

  });
}
