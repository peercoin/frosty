import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import "../data.dart";

void main() {
  group("SignatureAggregation + verifySignatureShare", () {

    late final List<SignPart1> part1s;
    late final SigningCommitmentSet commitments;
    late final SignDetails basicDetails;
    late final SignatureShare badShare;

    setUpAll(() async {
      await loadFrosty();
      part1s = getPart1s();
      commitments = getSignatureCommitments(part1s);
      basicDetails = SignDetails.keySpend(message: signMsgHash);
      badShare = SignatureShare.fromBytes(
        cl.hexToBytes(
          "84ee1adfe96d4670fc6fcf5def51bbfa886389f5bdb2e9b3ccf91824324e613c",
        ),
      );
    });

    ShareList getShares(SignDetails? details) => List.generate(
      2, (i) => (
        ids[i],
        getShare(part1s, i, details: details),
      ),
    );

    void expectValid(SignDetails details, cl.ECPublicKey pubkey) {

      final shares = getShares(details);

      final signature = SignatureAggregation(
        commitments: commitments,
        details: details,
        shares: shares,
        info: aggregateInfo,
      ).signature;

      expect(signature.verify(pubkey, signMsgHash), true);

      // Verify each share
      for (final share in shares) {
        expect(
          verifySignatureShare(
            commitments: commitments,
            details: details,
            id: share.$1,
            share: share.$2,
            publicShare: aggregateInfo.publicShares.list.firstWhere(
              (t) => t.$1 == share.$1,
            ).$2,
            groupKey: aggregateInfo.groupKey,
          ),
          true,
        );
      }

    }

    void expectValidKeySpend(cl.TapNode? mast) {
      final taproot = cl.Taproot(internalKey: groupPublicKey, mast: mast);
      final details = SignDetails.keySpend(
        message: signMsgHash,
        mastHash: mast?.hash,
      );
      expectValid(details, taproot.tweakedKey);
    }

    test(
      "produces a valid signature for the group key",
      () => expectValidKeySpend(null),
    );

    test(
      "produces a valid signature with MAST",
      () => expectValidKeySpend(cl.TapLeaf(cl.Script.fromAsm("OP_RETURN"))),
    );

    test(
      "produces valid signature for script spends",
      () => expectValid(
        SignDetails.scriptSpend(message: signMsgHash),
        groupPublicKey,
      ),
    );

    test(
      "bad share is not verified",
      () => expect(
        verifySignatureShare(
          commitments: commitments,
          details: basicDetails,
          id: ids[1],
          share: badShare,
          publicShare: aggregateInfo.publicShares.list[1].$2,
          groupKey: aggregateInfo.groupKey,
        ),
        false,
      ),
    );

    test("identifiable invalid share", () {

      // Use incorrect share for participant 2
      final sharesWithInvalid = [
        (ids[0], getShare(part1s, 0)),
        (ids[1], badShare),
      ];

      expect(
        () => SignatureAggregation(
          commitments: commitments,
          details: basicDetails,
          shares: sharesWithInvalid,
          info: aggregateInfo,
        ),
        throwsA(
          isA<InvalidAggregationShare>()
          .having((err) => err.culprit, "culprit", ids[1]),
        ),
      );

    });

    test("invalid inputs", () {

      // Incorrect number of commitments
      expect(
        () => SignatureAggregation(
          commitments: SigningCommitmentSet({
            ids.first: part1s[0].commitment,
          }),
          details: basicDetails,
          shares: getShares(null),
          info: aggregateInfo,
        ),
        throwsA(isA<InvalidAggregation>()),
      );

      // Incorrect number of shares
      expect(
        () => SignatureAggregation(
          commitments: commitments,
          details: basicDetails,
          shares: getShares(null).take(1).toList(),
          info: aggregateInfo,
        ),
        throwsA(isA<InvalidAggregation>()),
      );

      // Shares from wrong identifiers
      expect(
        () => SignatureAggregation(
          commitments: SigningCommitmentSet({
            ids[1]: part1s[1].commitment,
            ids[2]: part1s[2].commitment,
          }),
          details: basicDetails,
          shares: getShares(null),
          info: aggregateInfo,
        ),
        throwsA(isA<InvalidAggregation>()),
      );

    });

  });
}
