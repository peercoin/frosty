import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import "../data.dart";

void main() {
  group("SignatureAggregation", () {

    late List<SignPart1> part1s;
    late List<(Identifier, SignatureShare)> shares;
    setUp(() async {
      await loadFrosty();
      part1s = getPart1s();
      shares = List.generate(
        2, (i) => (Identifier.fromUint16(i+1), getShare(part1s, i)),
      );
    });

    test("produces a valid signature for the group key", () {

      final signature = SignatureAggregation(
        commitments: getSignatureCommitments(part1s),
        message: signMsgHash,
        shares: shares,
        publicInfo: publicInfo,
      ).signature;

      expect(
        signature.verify(
          groupPublicKey,
          signMsgHash,
        ),
        true,
      );

    });

    test("identifiable invalid share", () {
    });

    test("invalid inputs", () {
    });

  });
}
