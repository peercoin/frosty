import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';

// Example construction of testnet transaction
// The signature is unique each time but this example was used to construct the
// testnet transaction:
//    d5df5c240e8ef3bf90dbea78a3fd8832798659abd5e7bc8c61aace741b622eec
//
// Spends a 2 tPPC output using key-path and a 1 tPPC output using script-path
// from the tx:
//    004223970df85726b9d14312dc374b0c2899b1b67aeb0bf7501844eccf6fd505
void main() async {

  await loadFrosty();

  // Key share information

  final groupKey = cl.ECCompressedPublicKey.fromHex(
    "027f2b9f6b67de76a624c750226221a73f79280d91f3e14b42e0994950605804b2",
  );

  final privateShares = [
    "bafe4fab41fee3ca118cce1af9c2432189030d0e0249365787b8e71da37fdbb3",
    "57de65ea899d944895f9cb8c2790e17bcd7e6bdeb81e3b199d6c4bea015607f9",
    "f4be7c29d13c44c71a66c8fd555f7fd4cca8a7961d3be01772f20f432f627580",
  ].map((hex) => cl.ECPrivateKey.fromHex(hex)).toList();

  final publicShareKeys = [
    "030251582b6921a9aba190a761740a8b07f2d1e11aa66ce2f2b039d387f802ba8b",
    "03fa55e35e8390e0b636b766d1db0b89f436b65889cd04dd039052655ed810c9a3",
    "0355a1a070b2d0d2c47e37854e969e8817151597e0d37d0b7ebb21026fb09c90bc",
  ].map((hex) => cl.ECCompressedPublicKey.fromHex(hex)).toList();

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

  // Construct Taproot information

  final taproot = cl.Taproot(internalKey: groupKey);

  final spendLeaf = cl.TapLeaf(
    cl.Script([
      cl.ScriptPushData(groupKey.x),
      cl.ScriptOpCode.fromName("CHECKSIG"),
    ]),
  );

  final taprootWithMast = cl.Taproot(
    internalKey: cl.NUMSPublicKey.fromRTweak(Uint8List(32)..last = 1),
    mast: spendLeaf,
  );

  final keyOnlyAddress = cl.P2TRAddress.fromTaproot(
    taproot, hrp: cl.Network.testnet.bech32Hrp,
  );

  final scriptOnlyAddress = cl.P2TRAddress.fromTaproot(
    taprootWithMast, hrp: cl.Network.testnet.bech32Hrp,
  );

  print("Key-path Taproot Address: $keyOnlyAddress");
  print("Script-path Taproot Address: $scriptOnlyAddress");

  // Construct spending transaction and get signature hash

  final prevTxHex
    = "004223970df85726b9d14312dc374b0c2899b1b67aeb0bf7501844eccf6fd505";

  final keyInput = cl.TaprootKeyInput(
    prevOut: cl.OutPoint.fromHex(prevTxHex, 0),
  );

  final scriptInput = cl.TaprootScriptInput.fromTaprootLeaf(
    prevOut: cl.OutPoint.fromHex(prevTxHex, 2),
    taproot: taprootWithMast,
    leaf: spendLeaf,
  );

  final unsignedTx = cl.Transaction(
    inputs: [keyInput, scriptInput],
    outputs: [
      cl.Output.fromAddress(
        cl.CoinUnit.coin.toSats("2.9"),
        cl.Address.fromString(
          "mnhRNbngwdxrS1MpRYGPYuHAY26weRNkXS",
          cl.Network.testnet,
        ),
      ),
    ],
  );

  // This is how the sigantures are constructed from each participants's shares
  // given the SignDetails
  cl.SchnorrSignature makeSignature(SignDetails details) {

    // Generate nonces for first two participants
    final nonces = privateShares.take(2).map(
      (share) => SignPart1(privateShare: share),
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
            info: participantInfos[i].signing,
          ).share
        );
      }
    );

    // Aggregate signature shares into final signature
    return SignatureAggregation(
      commitments: commitments,
      details: details,
      shares: shares,
      info: participantInfos.first.aggregate,
    ).signature;

  }

  // Create signatures given the appropriate spending details

  final prevOuts = [
    cl.Output.fromProgram(
      cl.CoinUnit.coin.toSats("2"),
      cl.P2TR.fromTaproot(taproot),
    ),
    cl.Output.fromProgram(
      cl.CoinUnit.coin.toSats("1"),
      cl.P2TR.fromTaproot(taprootWithMast),
    ),
  ];

  final keyHash = cl.TaprootSignatureHasher(
    cl.TaprootKeySignDetails(
      tx: unsignedTx,
      inputN: 0,
      prevOuts: prevOuts,
    ),
  ).hash;

  final keySignature = makeSignature(
    SignDetails.keySpend(message: keyHash),
  );

  final scriptHash = cl.TaprootSignatureHasher(
    cl.TaprootScriptSignDetails(
      tx: unsignedTx,
      inputN: 1,
      prevOuts: prevOuts,
      leafHash: spendLeaf.hash,
    ),
  ).hash;

  final scriptSignature = makeSignature(
    SignDetails.scriptSpend(message: scriptHash),
  );

  // Final transaction
  final completeTx = unsignedTx
    .replaceInput(
      keyInput.addSignature(cl.SchnorrInputSignature(keySignature)),
      0,
    )
    .replaceInput(
      scriptInput.updateStack([cl.SchnorrInputSignature(scriptSignature).bytes]),
      1,
    );

  // Print hex of final signed transaction
  print("FROST signed transaction hex: ${completeTx.toHex()}");

}
