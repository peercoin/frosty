import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgCommitmentSet", () {

    final commitBytes = [
      hexToBytes(
        "00230f8ab3020389ae0c08ebcd4ba00d64164b24a8e24ebadeadb782b8442d173aab6717bb910103c852b1505ab3c1a4c105ad3187b309313522d1b1af6b868fd200b6d14990bd4140b7092c6e1e762a0afa4eeb01636098b209b940c953e9d83b050e73c2d4ce133d6093ddb2bf7c05b2df0301eb3e6c443f10f21b88b762ab8586b930d7325a448b",
      ),
      hexToBytes(
        "00230f8ab30203bcfe7123f0c91250f79f71c5f76d1ee12ecaa0376bf920b137a32a8ec3efc1a203740ba5ba324bc8e5c9885f9cd688df9ec83fa804ae9e6df48ddf31b62c014dfa4096085b9a35fc641ecfa0b54fa64a303c34cc87507afde1a5b0833e969c18c86acfa26cb9a19a9f2e1591e9af9f894c9f158247f67e1a7ac549626b89fee7840c",
      ),
      hexToBytes(
        "00230f8ab302020b96817a46fecb9a5666a4c53b96b5680e3188ddf120a0b5fb4e36272865512c03a56e27aa412e1a04b428bbc91f3d77488c166eff33ddb87a3e3aadeff7bbc25740e0f0a501981e0ff57cf463fbfeb79fe85b84af3208cd27650261a868a170628822c9a1d67f8a601326439299277a4bd963af07fcec19ffb084ecc0952188dd22",
      ),
    ];

    final validBytes = commitmentSetBytes(commitBytes);

    late List<DkgCommitmentPair> pairs;
    setUpAll(() async {
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
      "bd3ed1123196b8076c60458c1b2584a8d5f01d02a5f4c167f9602f5311e5f25e",
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
