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
        details: SignDetails.keySpend(message: signMsgHash, mastHash: mast?.hash),
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

      // Use incorrect share for participant 2
      final sharesWithInvalid = [
        (Identifier.fromUint16(1), getShare(part1s, 0)),
        (
          Identifier.fromUint16(2),
          SignatureShare.fromBytes(
            hexToBytes(
              "84ee1adfe96d4670fc6fcf5def51bbfa886389f5bdb2e9b3ccf91824324e613c",
            ),
          ),
        ),
      ];

      expect(
        () => SignatureAggregation(
          commitments: getSignatureCommitments(part1s),
          details: SignDetails.keySpend(message: signMsgHash),
          shares: sharesWithInvalid,
          publicInfo: publicInfo,
        ),
        throwsA(
          isA<InvalidAggregationShare>()
          .having((err) => err.culprit, "culprit", Identifier.fromUint16(2)),
        ),
      );

    });

    test("invalid inputs", () {

      // Incorrect number of commitments
      expect(
        () => SignatureAggregation(
          commitments: SigningCommitmentSet([
            (Identifier.fromUint16(1), part1s[0].commitment),
          ]),
          details: SignDetails.keySpend(message: signMsgHash),
          shares: getShares(null),
          publicInfo: publicInfo,
        ),
        throwsA(isA<InvalidAggregation>()),
      );

      // Incorrect number of shares
      expect(
        () => SignatureAggregation(
          commitments: getSignatureCommitments(part1s),
          details: SignDetails.keySpend(message: signMsgHash),
          shares: getShares(null).take(1).toList(),
          publicInfo: publicInfo,
        ),
        throwsA(isA<InvalidAggregation>()),
      );

      // Shares from wrong identifiers
      expect(
        () => SignatureAggregation(
          commitments: SigningCommitmentSet([
            (Identifier.fromUint16(2), part1s[1].commitment),
            (Identifier.fromUint16(3), part1s[2].commitment),
          ]),
          details: SignDetails.keySpend(message: signMsgHash),
          shares: getShares(null),
          publicInfo: publicInfo,
        ),
        throwsA(isA<InvalidAggregation>()),
      );

    });

  });
}
