import 'dart:typed_data';

import 'package:coinlib/coinlib.dart' as cl;
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
        3,
        (i) => {
          for (int j = 0; j < 3; j++)
            if (j != i) ids[j]: eachPart2[j].sharesToGive[ids[i]]!,
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
        expect(info.private.identifier, isIn(pkShares.map((e) => e.$1)));
        expect(info.private.share.pubkey, isIn(pkShares.map((e) => e.$2)));
        expect(info.group.threshold, 2);
        expect(info.groupKey.compressed, true);
        expect(pkShares.map((e) => e.$2.compressed), everyElement(true));
      }

      // Expect private shares to be unique
      expect(
        infos.map((i) => cl.bytesToHex(i.private.share.data)).toSet().length,
        3,
      );

      // Expect public shares to be identical and encode to the same bytes
      expect(infos.map((i) => i.publicShares.toHex()).toSet().length, 1);
    });

    test("round-two secret round trips and remains usable", () {
      final bytes = eachPart2.first.secret.toBytes();
      final restored = DkgRound2Secret.fromBytes(bytes);
      eachPart2.first.secret.dispose();
      final info = DkgPart3(
        identifier: ids.first,
        round2Secret: restored,
        commitments: commitmentSet,
        receivedShares: eachReceivedShares.first,
      ).participantInfo;

      expect(info.private.identifier, ids.first);
      expect(
        info.private.share.pubkey,
        info.publicShares.list.singleWhere((entry) => entry.$1 == ids.first).$2,
      );
      for (final invalid in [
        Uint8List(0),
        Uint8List.sublistView(bytes, 1),
        Uint8List.fromList([...bytes, 0]),
      ]) {
        expect(
          () => DkgRound2Secret.fromBytes(invalid),
          throwsA(isA<InvalidDkgRound2Secret>()),
        );
      }
    });

    test("secret buffers can be cleared without corrupting later exports", () {
      final secret = eachPart2.first.secret;
      final bytes = secret.toBytes();
      final expected = Uint8List.fromList(bytes);
      final restored = DkgRound2Secret.fromBytes(bytes);

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

    test("rejects a checkpoint with an altered private scalar", () {
      final bytes = eachPart2.first.secret.toBytes();
      // This fixture ends in the 32-byte scalar followed by the single-byte
      // threshold (2) and participant count (3) in the upstream postcard format.
      expect(bytes[bytes.length - 2], 2);
      expect(bytes.last, 3);
      bytes[bytes.length - 3] ^= 1;
      expect(
        () => DkgRound2Secret.fromBytes(bytes),
        throwsA(isA<InvalidDkgRound2Secret>()),
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
          receivedShares: {ids[1]: eachPart2[1].sharesToGive[ids[0]]!},
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
              ids[2 - i]: eachReceivedShares.first[ids[i + 1]]!,
          },
        ),
        throwsA(isA<InvalidPart3>()),
      );
    });
  });
}
