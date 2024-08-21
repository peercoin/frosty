import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';

/// Information in addition to the FROST key required for BIP32 derivation
class HDKeyInfo with Writable {

  /// This chaincode is the SHA256 hash of the string "FrostTaprootBIP32".
  /// This can be public without allowing people to derive any information
  /// without also knowing the master public key.
  static Uint8List fixedChaincode = hexToBytes(
    "483436cd3215432748a55b1942f2667e858b473e85accc16238b517d0bee6614",
  );

  /// Fixed master HD information using the [fixedChaincode].
  static HDKeyInfo master = HDKeyInfo(
    chaincode: fixedChaincode,
    depth: 0,
    index: 0,
    parentFingerprint: 0,
  );

  final Uint8List chaincode;
  final int depth;
  final int index;
  final int parentFingerprint;

  static void _checkIndex(int index) {
    RangeError.checkValueInInterval(index, 0, 0x7fffffff, "index");
  }

  HDKeyInfo({
    required Uint8List chaincode,
    required this.depth,
    required this.index,
    required this.parentFingerprint,
  }) : chaincode = Uint8List.fromList(chaincode) {
    checkBytes(chaincode, 32, name: "Chaincode");
    RangeError.checkValueInInterval(depth, 0, 0xff, "depth");
    _checkIndex(index);
    RangeError.checkValueInInterval(
      parentFingerprint, 0, 0xffffffff, "parentFingerprint",
    );
  }

  HDKeyInfo.fromReader(BytesReader reader) : this(
    chaincode: reader.readSlice(32),
    depth: reader.readUInt8(),
    index: reader.readUInt32(),
    parentFingerprint: reader.readUInt32(),
  );

  /// Convenience constructor to construct from serialised [bytes].
  HDKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  HDKeyInfo.fromHex(String hex) : this.fromBytes(hexToBytes(hex));

  @override
  void write(Writer writer) {
    writer.writeSlice(chaincode);
    writer.writeUInt8(depth);
    writer.writeUInt32(index);
    writer.writeUInt32(parentFingerprint);
  }

  /// Given the group public key and index to derive a child key, a tuple is
  /// returned that contains the required tweak and new [HDKeyInfo].
  (Uint8List, HDKeyInfo) deriveTweakAndInfo(ECPublicKey groupKey, int index) {

    _checkIndex(index);

    Uint8List data = Uint8List(37);
    data.setRange(0, 33, groupKey.data);
    data.buffer.asByteData().setUint32(33, index);

    final i = hmacSha512(chaincode, data);
    final tweak = i.sublist(0, 32);
    final newChainCode = i.sublist(32);

    final id = hash160(groupKey.data);
    final fingerprint = id.buffer.asByteData().getUint32(0);

    return (
      tweak,
      HDKeyInfo(
        chaincode: newChainCode,
        depth: depth+1,
        index: index,
        parentFingerprint: fingerprint,
      ),
    );

  }

}
