import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';

final groupPublicKeyHex
  = "027f2b9f6b67de76a624c750226221a73f79280d91f3e14b42e0994950605804b2";
final groupPublicKey = ECPublicKey.fromHex(groupPublicKeyHex);

final chainCodeHex = bytesToHex(HDKeyInfo.fixedChaincode);

final tweakedGroupKeyHex
  = "025cb7dcabf7173e27de4dae2944e2b9ba1153ef2af326a12ed1c71f11d8b53cc8";
final tweakedGroupKey = ECPublicKey.fromHex(tweakedGroupKeyHex);

final uncompressedPk = ECPublicKey.fromHex(
  "0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8",
);

final privateSharesHex = [
  "bafe4fab41fee3ca118cce1af9c2432189030d0e0249365787b8e71da37fdbb3",
  "57de65ea899d944895f9cb8c2790e17bcd7e6bdeb81e3b199d6c4bea015607f9",
  "f4be7c29d13c44c71a66c8fd555f7fd4cca8a7961d3be01772f20f432f627580",
];

final tweakedPrivateShareHex = [
  "e6fca856af9eb93fcf50743fde44a0f43c78e358c27d321bf66084d8587675f1",
  "83dcbe95f73d69be53bd71b10c133f4e80f44229785236de0c13e9a4b64ca237",
  "20bcd4d53edc1a3cd82a6f2239e1dda8c56fa0fa2e273ba021c74e711422ce7d",
];

final privateShares = privateSharesHex.map(
  (hex) => ECPrivateKey.fromHex(hex),
).toList();

final publicShareKeyHex = [
  "030251582b6921a9aba190a761740a8b07f2d1e11aa66ce2f2b039d387f802ba8b",
  "03fa55e35e8390e0b636b766d1db0b89f436b65889cd04dd039052655ed810c9a3",
  "0355a1a070b2d0d2c47e37854e969e8817151597e0d37d0b7ebb21026fb09c90bc",
];

final tweakedPublicShareKeyHex = [
  "0321255d75b238991da00819c966aaf4b4eb28f550ecbbf24fe812bce86e59fcca",
  "03a64fb53187fb3ccc9db9c25ea230eece9d470bfe2368963e0e8386894b6c7f07",
  "03eb98b2b9dfa0310af3bf100c61be10cebd1ba3ef50e303476f8d9e36f70aa3c4",
];

final publicShares = List.generate(
  3,
  (i) => (
    Identifier.fromUint16(i+1),
    ECPublicKey.fromHex(publicShareKeyHex[i]),
  ),
);

// Determined as an invalid tweak for the underlying private key obtained via
// Lagrange interpolation of private shares.
final invalidGroupTweak
  = "e1e1c694059fccb472e02f56340c5b3630d60b90121d0ee20d9f3ac85ac2d315";

// Invalid tweak for the first share that leads to scalar equal to 0
final invalidShareTweak
  = "4501b054be011c35ee7331e5063dbcdd31abcfd8acff69e43819776f2cb6658e";

final groupInfo = GroupKeyInfo(
  publicKey: groupPublicKey,
  threshold: 2,
);

final publicSharesInfo = PublicSharesKeyInfo(publicShares: publicShares);
final aggregateInfo = AggregateKeyInfo(
  group: groupInfo,
  publicShares: publicSharesInfo,
);

ParticipantKeyInfo getParticipantInfo(int i) => ParticipantKeyInfo(
  group: groupInfo,
  publicShares: publicSharesInfo,
  private: PrivateKeyInfo(
    identifier: Identifier.fromUint16(i+1),
    share: privateShares[i],
  ),
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
    SigningKeyInfo? info,
    Uint8List? mastHash,
  }
) => SignPart2(
  identifier: identifier ?? Identifier.fromUint16(i+1),
  details: SignDetails.keySpend(message: signMsgHash, mastHash: mastHash),
  ourNonce: ourNonce ?? part1s[i].nonce,
  commitments: commitmentList != null
    ? SigningCommitmentSet(commitmentList)
    : getSignatureCommitments(part1s),
  info: info ?? getParticipantInfo(i).signing,
).share;
