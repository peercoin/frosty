import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import "../data.dart";

void main() {
  group("SignPart2", () {

    late List<SignPart1> part1s;
    setUp(() async {
      await loadFrosty();
      part1s = List.generate(
        3,
        (i) => SignPart1(privateShare: privateShares[i]),
      );
    });

    SignatureShare getShare(
      int i, {
        Identifier? identifier,
        SignNonce? ourNonce,
        SigningCommitmentList? commitmentList,
        FrostPrivateInfo? privateInfo,
      }
    ) => SignPart2(
      identifier: identifier ?? Identifier.fromUint16(i+1),
      message: hexToBytes("0102030405ff"),
      ourNonce: ourNonce ?? part1s[i].nonce,
      commitments: SigningCommitmentSet(
        commitmentList ?? List.generate(
          3,
          (i) => (
            Identifier.fromUint16(i+1),
            part1s[i].commitment,
          ),
        ),
      ),
      privateInfo: privateInfo ?? getPrivateInfo(i),
    ).share;

    test("provides the same signature share per participant each time", () {

      List<String> shares = [];
      for (int i = 0; i < 3; i++) {
        final participantShares = List.generate(
          2, (_) => bytesToHex(getShare(i).toBytes()),
        );
        expect(participantShares.first, participantShares.last);
        shares.addAll(participantShares);
      }

      print(shares.first);

      expect(shares.toSet().length, 3);

    });

    test("invalid inputs", () {

      void expectInvalid(void Function() f) => expect(
        () => f(), throwsA(isA<InvalidSignPart2>()),
      );

      // Wrong identifier
      expectInvalid(() => getShare(0, identifier: Identifier.fromUint16(2)));

      // Wrong nonce
      expectInvalid(() => getShare(0, ourNonce: part1s[1].nonce));

      // Too few commitments
      expectInvalid(() => getShare(
        0, commitmentList: [
          (Identifier.fromUint16(1), part1s.first.commitment),
        ],
      ),);

    });

  });
}
