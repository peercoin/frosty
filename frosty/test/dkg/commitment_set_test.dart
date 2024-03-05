import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

void main() {
  group("DkgCommitmentSet", () {

    final commitBytes = [
      hexToBytes(
        "0203ec52b518bc6d4188b1e93cbe88015e1913030dde8da59499a1162bb8ee563d6f0283acc6a2e9036d1769414b134bd3fc5c1774a1bbf2afe6a7d45e13bf164271844102c32bbcff3b782bba0a4e5ea7982b4f0900b1cf56b8f0547d88101a2ebca65bbb7984060cc61a1e01b2a7e3e04b05baa1c8a8700ca233ee19b88a8a0f6401158cf49d8cce",
      ),
      hexToBytes(
        "02022fcc2a198592e4216d0e9c05b038967436dce53f3b99cdf2df3677158e88d68c03fb76aca225a8a6b20848e23ca509254f01d9c027194abb694d75f4b3bbaba05a4102ee051380abb664db8066f8dc6fe7cbaac9472d06376751012c63dc9deb8d6a264e662c35b0d8cb8ec35e2affcca948bbca8715a0537946336083b4b2b58682f4f49d8cce",
      ),
      hexToBytes(
      "02033f1c636b865af376d17fc948958e6718d8131aaa97748fee16d9399060eb8be30350893e0e04f37ab161948bfb87a06954b16f3184dc09e3fef889876cffe83d7441031790bbdee5cf02bbe18ab69d87255f28ce497793e058ca8f3cad63d6ffcc3363dd48cdc34716973a766809d5434990013c3cfcc6100fd751b5f27617db596e8af49d8cce",
      ),
    ];

    final validBytes = Uint8List.fromList([
      3, 0,
      ...Uint8List(32)..last=1,
      commitBytes[0].length,
      ...commitBytes[0],
      ...Uint8List(32)..last=2,
      commitBytes[1].length,
      ...commitBytes[1],
      ...Uint8List(32)..last=3,
      commitBytes[2].length,
      ...commitBytes[2],
    ]);

    late List<CommitmentPair> pairs;
    setUp(() async {
      await loadFrosty();
      pairs = List.generate(
        3,
        (i) => (
          Identifier.fromUint16(i+1),
          DkgPublicCommitment.fromBytes(commitBytes[i]),
        ),
      );
    });

    void expectHash(DkgCommitmentSet commitments) => expect(
      bytesToHex(commitments.hash),
      "4a7605b740be9a37b5b88bc6ce21173997d0e2581f8caa30b760e38537a79610",
    );

    test("provides expected hash regardless of order", () {
      expectHash(DkgCommitmentSet(pairs));
      expectHash(DkgCommitmentSet([pairs[2], pairs[1], pairs[0]]));
    });

    test("valid bytes", () {
      final commitments = DkgCommitmentSet.fromReader(BytesReader(validBytes));
      expectHash(commitments);
      expect(commitments.toHex(), bytesToHex(validBytes));
    });

    test("invalid bytes", () {

      void expectThrows<T>(Uint8List invalid) => expect(
        () => DkgCommitmentSet.fromReader(BytesReader(invalid)),
        throwsA(isA<T>()),
      );

      expectThrows<OutOfData>(Uint8List(0));
      expectThrows<InvalidPublicCommitment>(
        Uint8List.fromList(List.from(validBytes)..removeAt(1)),
      );

    });

  });
}
