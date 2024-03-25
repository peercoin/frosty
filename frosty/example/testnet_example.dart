import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';

// Example construction of testnet transaction
// The signature is unique each time but this example was used to construct the
// testnet transaction:
//    40dff55d60fe60319d1ccae0ea473ede7cb45b55396b0c020c439b94d4732ee0
//
// Spends a 2 tPPC output using key-path and a 1 tPPC output using script-path
// from the tx:
//    e45500a001a35b3da0c5bdf4a67a254fac1265cf22ec8dd5c75201bf512ebf7a
void main() async {

  await loadFrosty();

  // Key share information

  final groupKey = ECPublicKey.fromHex(
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
  ].map((hex) => ECPublicKey.fromHex(hex)).toList();

  final publicShares = List.generate(
    3,
    (i) => (Identifier.fromUint16(i+1), publicShareKeys[i]),
  );

  final publicInfo = FrostPublicInfo(
    groupPublicKey: groupKey,
    publicShares: publicShares,
    threshold: 2,
  );

  // Construct Taproot information

  final taproot = Taproot(internalKey: groupKey);

  final spendLeaf = TapLeaf(
    Script([
      ScriptPushData(groupKey.x),
      ScriptOpCode.fromName("CHECKSIG"),
    ]),
  );

  final taprootWithMast = Taproot(
    internalKey: NUMSPublicKey.fromRTweak(Uint8List(32)..last = 1),
    mast: spendLeaf,
  );

  final keyOnlyAddress = P2TRAddress.fromTaproot(
    taproot, hrp: Network.testnet.bech32Hrp,
  );

  final scriptOnlyAddress = P2TRAddress.fromTaproot(
    taprootWithMast, hrp: Network.testnet.bech32Hrp,
  );

  print("Key-path Taproot Address: $keyOnlyAddress");
  print("Script-path Taproot Address: $scriptOnlyAddress");

  // Construct spending transaction and get signature hash

  final prevTxHex
    = "e45500a001a35b3da0c5bdf4a67a254fac1265cf22ec8dd5c75201bf512ebf7a";

  final keyInput = TaprootKeyInput(
    prevOut: OutPoint.fromHex(prevTxHex, 1),
  );

  final scriptInput = TaprootScriptInput.fromTaprootLeaf(
    prevOut: OutPoint.fromHex(prevTxHex, 2),
    taproot: taprootWithMast,
    leaf: spendLeaf,
  );

  final unsignedTx = Transaction(
    inputs: [keyInput, scriptInput],
    outputs: [
      Output.fromAddress(
        CoinUnit.coin.toSats("2.9"),
        Address.fromString(
          "mnhRNbngwdxrS1MpRYGPYuHAY26weRNkXS",
          Network.testnet,
        ),
      ),
    ],
  );

  // This is how the sigantures are constructed from each participants's shares
  // given the SignDetails
  SchnorrSignature makeSignature(SignDetails details) {

    // Generate nonces for first two participants
    final nonces = privateShares.take(2).map(
      (share) => SignPart1(privateShare: share),
    ).toList();

    // Collect commitments
    final commitments = SigningCommitmentSet(
      List.generate(
        2,
        (i) => (Identifier.fromUint16(i+1), nonces[i].commitment),
      ),
    );

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
            ourNonce: nonces[i].nonce,
            commitments: commitments,
            privateInfo: FrostPrivateInfo(
              identifier: id,
              privateShare: privateShares[i],
              public: publicInfo,
            ),
          ).share
        );
      }
    );

    // Aggregate signature shares into final signature
    return SignatureAggregation(
      commitments: commitments,
      details: details,
      shares: shares,
      publicInfo: publicInfo,
    ).signature;

  }

  // Create signatures given the appropriate spending details

  final prevOuts = [
    Output.fromProgram(
      CoinUnit.coin.toSats("2"),
      P2TR.fromTaproot(taproot),
    ),
    Output.fromProgram(
      CoinUnit.coin.toSats("1"),
      P2TR.fromTaproot(taprootWithMast),
    ),
  ];

  final keyHash = TaprootSignatureHasher(
    tx: unsignedTx,
    inputN: 0,
    prevOuts: prevOuts,
    hashType: SigHashType.all(),
  ).hash;

  final keySignature = makeSignature(
    SignDetails.keySpend(message: keyHash),
  );

  final scriptHash = TaprootSignatureHasher(
    tx: unsignedTx,
    inputN: 1,
    prevOuts: prevOuts,
    hashType: SigHashType.all(),
    leafHash: spendLeaf.hash,
  ).hash;

  final scriptSignature = makeSignature(
    SignDetails.scriptSpend(message: scriptHash),
  );

  // Final transaction
  final completeTx = unsignedTx
    .replaceInput(
      keyInput.addSignature(SchnorrInputSignature(keySignature)),
      0,
    )
    .replaceInput(
      scriptInput.updateStack([SchnorrInputSignature(scriptSignature).bytes]),
      1,
    );

  // Print hex of final signed transaction
  print("FROST signed transaction hex: ${completeTx.toHex()}");

}
