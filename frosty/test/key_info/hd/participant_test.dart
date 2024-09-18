import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../../data.dart';
import '../helpers.dart';
import '../participant_test.dart' as non_hd;

final validHex = "${chainCodeHex}000000000000000000${non_hd.validHex}";

final hdParticipantInfo = HDParticipantKeyInfo.master(
  group: groupInfo,
  publicShares: publicSharesInfo,
  private: getParticipantInfo(0).signing.private,
);

// Just the participant info
final zeroTweakedHex = non_hd.validHex;
final tweakedHex = non_hd.tweakedHex;

void main() {

  group("HDParticipantKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      zeroTweakedHex: zeroTweakedHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromHex: (hex) => HDParticipantKeyInfo.fromHex(hex),
      getValidObj: () => hdParticipantInfo,
    );

    test(".derive()", () {
      final newHdParticipant = hdParticipantInfo.derive(0x7fffffff).derive(0);
      expectDerivedGroup(newHdParticipant.group);
      expectDerivedPublicShares(newHdParticipant.publicShares);
      expectDerivedPrivate(newHdParticipant.private);
    });

    test("can produce valid signatures", () {

      final derivedParticipantInfos = List.generate(
        2, // Only need 2
        (i) => ParticipantKeyInfo(
          group: groupInfo,
          publicShares: publicSharesInfo,
          private: getParticipantInfo(i).signing.private,
        ),
      );

      final part1s = derivedParticipantInfos.map(
        (info) => SignPart1(privateShare: info.private.share),
      ).toList();

      // Collect commitments
      final commitments = getSignatureCommitments(part1s);

      final signMsgHash = hexToBytes(
        "2514a6272f85cfa0f45eb907fcb0d121b808ed37c6ea160a5a9046ed5526d555",
      );
      final details = SignDetails.keySpend(message: signMsgHash);

      // Generate signature shares
      final shares = List.generate(
        2,
        (i) {
          final id = Identifier.fromUint16(i+1);
          return (
            id,
            SignPart2(
              identifier: id,
              details: details,
              ourNonce: part1s[i].nonce,
              commitments: commitments,
              info: derivedParticipantInfos[i].signing,
            ).share
          );
        }
      );

      // Aggregate signature shares into final signature
      final sig = SignatureAggregation(
        commitments: commitments,
        details: details,
        shares: shares,
        info: derivedParticipantInfos.first.aggregate,
      ).signature;

      expect(
        sig.verify(
          Taproot(
            internalKey: derivedParticipantInfos.first.groupKey,
          ).tweakedKey,
          signMsgHash,
        ),
        true,
      );

    });

  });

}
