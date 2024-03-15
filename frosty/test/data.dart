import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';

final groupPublicKey = ECPublicKey.fromHex(
  "027f2b9f6b67de76a624c750226221a73f79280d91f3e14b42e0994950605804b2",
);

final uncompressedPk = ECPublicKey.fromHex(
  "0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8",
);

final privateShares = [
  ECPrivateKey.fromHex(
    "bafe4fab41fee3ca118cce1af9c2432189030d0e0249365787b8e71da37fdbb3",
  ),
  ECPrivateKey.fromHex(
    "57de65ea899d944895f9cb8c2790e17bcd7e6bdeb81e3b199d6c4bea015607f9",
  ),
  ECPrivateKey.fromHex(
    "f4be7c29d13c44c71a66c8fd555f7fd4cca8a7961d3be01772f20f432f627580",
  ),

];

final publicShares = [
  (
   Identifier.fromUint16(1),
   ECPublicKey.fromHex(
     "030251582b6921a9aba190a761740a8b07f2d1e11aa66ce2f2b039d387f802ba8b",
   ),
  ),
  (
   Identifier.fromUint16(2),
   ECPublicKey.fromHex(
     "03fa55e35e8390e0b636b766d1db0b89f436b65889cd04dd039052655ed810c9a3",
   ),
  ),
  (
   Identifier.fromUint16(3),
   ECPublicKey.fromHex(
     "0355a1a070b2d0d2c47e37854e969e8817151597e0d37d0b7ebb21026fb09c90bc",
   ),
  ),
];

final publicInfo = FrostPublicInfo(
  groupPublicKey: groupPublicKey,
  publicShares: publicShares,
  threshold: 2,
);

FrostPrivateInfo getPrivateInfo(int i) => FrostPrivateInfo(
  identifier: Identifier.fromUint16(i+1),
  privateShare: privateShares[i],
  public: publicInfo,
);

List<SignPart1> getPart1s() => List.generate(
  3,
  (i) => SignPart1(privateShare: privateShares[i]),
);

final signMsgHash = hexToBytes(
  "2514a6272f85cfa0f45eb907fcb0d121b808ed37c6ea160a5a9046ed5526d555",
);

SigningCommitmentSet getSignatureCommitments(
  List<SignPart1> part1s,
) => SigningCommitmentSet(
  List.generate(
    2, (i) => (Identifier.fromUint16(i+1), part1s[i].commitment),
  ),
);

SignatureShare getShare(
  List<SignPart1> part1s, int i, {
    Identifier? identifier,
    SignNonce? ourNonce,
    SigningCommitmentList? commitmentList,
    FrostPrivateInfo? privateInfo,
    Uint8List? mastHash,
  }
) => SignPart2(
  identifier: identifier ?? Identifier.fromUint16(i+1),
  details: SignDetails(message: signMsgHash, mastHash: mastHash),
  ourNonce: ourNonce ?? part1s[i].nonce,
  commitments: commitmentList != null
    ? SigningCommitmentSet(commitmentList)
    : getSignatureCommitments(part1s),
  privateInfo: privateInfo ?? getPrivateInfo(i),
).share;
