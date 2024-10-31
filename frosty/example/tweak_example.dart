import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';

void main() async {

  await loadFrosty();

  final groupKey = ECCompressedPublicKey.fromHex(
    "027f2b9f6b67de76a624c750226221a73f79280d91f3e14b42e0994950605804b2",
  );

  final privateShares = [
    "bafe4fab41fee3ca118cce1af9c2432189030d0e0249365787b8e71da37fdbb3",
    "57de65ea899d944895f9cb8c2790e17bcd7e6bdeb81e3b199d6c4bea015607f9",
    "f4be7c29d13c44c71a66c8fd555f7fd4cca8a7961d3be01772f20f432f627580",
  ].map((hex) => ECPrivateKey.fromHex(hex)).toList();

  final publicShareKeys = [
    "030251582b6921a9aba190a761740a8b07f2d1e11aa66ce2f2b039d387f802ba8b",
    "03fa55e35e8390e0b636b766d1db0b89f436b65889cd04dd039052655ed810c9a3",
    "0355a1a070b2d0d2c47e37854e969e8817151597e0d37d0b7ebb21026fb09c90bc",
  ].map((hex) => ECCompressedPublicKey.fromHex(hex)).toList();

  final publicShares = List.generate(
    3,
    (i) => (Identifier.fromUint16(i+1), publicShareKeys[i]),
  );

  final groupInfo = GroupKeyInfo(groupKey: groupKey, threshold: 2);
  final publicSharesInfo = PublicSharesKeyInfo(publicShares: publicShares);
  final participantInfos = List.generate(
    3,
    (i) => ParticipantKeyInfo(
      group: groupInfo,
      publicShares: publicSharesInfo,
      private: PrivateKeyInfo(
        identifier: Identifier.fromUint16(i+1),
        share: privateShares[i],
      ),
    ),
  );

  // Check signature without derivation first

  final nonces = privateShares.take(2).map(
    (share) => SignPart1(privateShare: share),
  ).toList();

  // Collect commitments
  final commitments = SigningCommitmentSet({
    for (int i = 0; i < 2; i++)
      Identifier.fromUint16(i+1): nonces[i].commitment,
  });

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
          ourNonces: nonces[i].nonces,
          commitments: commitments,
          info: participantInfos[i].signing,
        ).share
      );
    }
  );

  // Aggregate signature shares into final signature
  final sig = SignatureAggregation(
    commitments: commitments,
    details: details,
    shares: shares,
    info: participantInfos.first.aggregate,
  ).signature;

  print(sig.verify(Taproot(internalKey: groupKey).tweakedKey, signMsgHash));

  // Try derivation and check

  final tweak = hexToBytes(
    "55a1a070b2d0d2c47e37854e969e8817151597e0d37d0b7ebb21026fb09c90bc",
  );

  final tweakedInfos = participantInfos.map(
    (info) => info.tweak(tweak)!,
  ).toList();

  {

    final nonces = tweakedInfos.take(2).map(
      (info) => SignPart1(privateShare: info.private.share),
    ).toList();

    // Collect commitments
    final commitments = SigningCommitmentSet({
      for (int i = 0; i < 2; i++)
        Identifier.fromUint16(i+1): nonces[i].commitment,
    });

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
            ourNonces: nonces[i].nonces,
            commitments: commitments,
            info: tweakedInfos[i].signing,
          ).share
        );
      }
    );

    // Aggregate signature shares into final signature
    final sig = SignatureAggregation(
      commitments: commitments,
      details: details,
      shares: shares,
      info: tweakedInfos.first.aggregate,
    ).signature;

    print(
      sig.verify(
        Taproot(internalKey: tweakedInfos.first.groupKey).tweakedKey,
        signMsgHash,
      ),
    );

  }

}
