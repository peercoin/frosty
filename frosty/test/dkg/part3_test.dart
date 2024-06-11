import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgPart3", () {

    late List<Identifier> ids;
    late List<DkgPart1> eachPart1;
    late DkgCommitmentSet commitmentSet;
    late List<DkgPart2> eachPart2;
    late List<Map<Identifier, DkgShareToGive>> eachReceivedShares;

    setUp(() async {

      await loadFrosty();
      (ids, eachPart1, commitmentSet) = genPart1();

      eachPart2 = List.generate(
        3,
        (i) => DkgPart2(
          identifier: ids[i],
          round1Secret: eachPart1[i].secret,
          commitments: commitmentSet,
        ),
      );

      eachReceivedShares = List.generate(
        3, (i) => {
          for (int j = 0; j < 3; j++)
            if (j != i) ids[j] : eachPart2[j].sharesToGive[ids[i]]!,
        },
      );

    });

    test("gives different key shares to participants", () {

      final infos = List.generate(
        3,
        (i) => DkgPart3(
          identifier: ids[i],
          round2Secret: eachPart2[i].secret,
          commitments: commitmentSet,
          receivedShares: eachReceivedShares[i],
        ).participantInfo,
      );

      for (int i = 0; i < 3; i++) {

        final info = infos[i];
        final pkShares = info.publicShares.list;

        expect(info.private.identifier, ids[i]);
        expect(
          info.private.identifier,
          isIn(pkShares.map((e) => e.$1)),
        );
        expect(
          info.private.share.pubkey,
          isIn(pkShares.map((e) => e.$2)),
        );
        expect(info.group.threshold, 2);
        expect(info.group.publicKey.compressed, true);
        expect(pkShares.map((e) => e.$2.compressed), everyElement(true));

      }

      // Expect private shares to be unique
      expect(
        infos.map((i) => bytesToHex(i.private.share.data)).toSet().length,
        3,
      );

      // Expect public shares to be identical and encode to the same bytes
      expect(
        infos.map((i) => i.publicShares.toHex()).toSet().length,
        1,
      );

    });

    void expectUseAfterFree() {
      expect(
        () => DkgPart3(
          identifier: ids.first,
          round2Secret: eachPart2.first.secret,
          commitments: commitmentSet,
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
      commitmentSet.list[1].$2.dispose();
      expectUseAfterFree();
    });

    test("cannot use received share after free", () {
      eachReceivedShares[0][ids[1]]!.dispose();
      expectUseAfterFree();
    });

    test("invalid round 3", () {

      // Wrong amount of commitments
      expect(
        () => DkgPart3(
          identifier: ids.first,
          round2Secret: eachPart2.first.secret,
          commitments: DkgCommitmentSet(commitmentSet.list.sublist(0, 2)),
          receivedShares: eachReceivedShares.first,
        ),
        throwsA(isA<InvalidPart3>()),
      );

      // Wrong amont of shares
      expect(
        () => DkgPart3(
          identifier: ids.first,
          round2Secret: eachPart2.first.secret,
          commitments: commitmentSet,
          receivedShares: { ids[1] : eachPart2[1].sharesToGive[ids[0]]! },
        ),
        throwsA(isA<InvalidPart3>()),
      );

      // Invalid shares.
      expect(
        () => DkgPart3(
          identifier: ids.first,
          round2Secret: eachPart2.first.secret,
          commitments: commitmentSet,
          receivedShares: {
            for (int i = 0; i < 2; i++)
              // Incorrect ID for share
              ids[2-i] : eachReceivedShares.first[ids[i+1]]!,
          },
        ),
        throwsA(isA<InvalidPart3>()),
      );

    });

  });
}
