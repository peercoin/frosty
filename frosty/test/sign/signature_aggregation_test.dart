import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import "../data.dart";

void main() {
  group("SignatureAggregation", () {

    late List<SignPart1> part1s;

    setUp(() async {
      await loadFrosty();
      part1s = getPart1s();
    });

    ShareList getShares(TapNode? mast) => List.generate(
      2, (i) => (
        Identifier.fromUint16(i+1),
        getShare(part1s, i, mastHash: mast?.hash),
      ),
    );

    void expectValid(TapNode? mast) {

      final taproot = Taproot(internalKey: groupPublicKey, mast: mast);

      final signature = SignatureAggregation(
        commitments: getSignatureCommitments(part1s),
        details: SignDetails(message: signMsgHash, mastHash: mast?.hash),
        shares: getShares(mast),
        publicInfo: publicInfo,
      ).signature;

      expect(signature.verify(taproot.tweakedKey, signMsgHash), true);

    }

    test(
      "produces a valid signature for the group key",
      () => expectValid(null),
    );

    test(
      "produces a valid signature with MAST",
      () => expectValid(TapLeaf(Script.fromAsm("OP_RETURN"))),
    );

    test("identifiable invalid share", () {
    });

    test("invalid inputs", () {
    });

  });
}
