import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import "../data.dart";

void main() {
  group("SignPart2", () {

    late List<SignPart1> part1s;
    setUpAll(() async {
      await loadFrosty();
      part1s = getPart1s();
    });

    test("provides the same signature share per participant each time", () {

      List<String> shares = [];
      // Only do two participants as that is the threshold
      for (int i = 0; i < 2; i++) {
        final participantShares = List.generate(
          2, (_) => bytesToHex(getShare(part1s, i).toBytes()),
        );
        expect(participantShares.first, participantShares.last);
        shares.addAll(participantShares);
      }

      expect(shares.toSet().length, 2);

    });

    test("invalid inputs", () {

      void expectInvalid(void Function() f) => expect(
        () => f(), throwsA(isA<InvalidSignPart2>()),
      );

      // Participant not part of commitments
      expectInvalid(() => getShare(part1s, 2));

      // Wrong nonce
      expectInvalid(() => getShare(part1s, 0, ourNonce: part1s[1].nonce));

      // Too few commitments
      expectInvalid(() => getShare(
        part1s, 0, commitmentList: [
          (Identifier.fromUint16(1), part1s.first.commitment),
        ],
      ),);

    });

  });
}
