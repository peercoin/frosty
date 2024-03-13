import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgCommitmentSet", () {
    final commitBytes = [
      hexToBytes(
        "00230f8ab30203c08d0599e8c604df77fb36266698ca5aa06e7cdddfa31e50074995afc0e543ba02b1f1567a0819837772d3c88e8419ee3d422deca8fd3d81b6507a97c0e70f9b684103b1e8c505225aefd1d7cb1dd4363f455e82d78d2099a8df977699f25832e0a11d9ff140ee435c9df7d019a2e589a752475e9a3153bfcb921bf7a83420f737a302",
      ),
      hexToBytes(
        "00230f8ab3020218b7d5330d82b77ef51400c601b09f22fac102e92911a738f222397075ea161003a9117967e1e7b0d111cfd99fb742d94c64d319e60ecb3452d8b93efb856baf074103600103d882d2ada6c7611591477712016da003435c572bd042620f10dd5a1405a2f656fb18d8fb916617f9c0b0a47f1f6017f8abdec14d71e6119b5755710681",
      ),
      hexToBytes(
        "00230f8ab302030ae4fcfbf7f039399cfd2d766c5c22200ac136597658592009c1353ef0f54e89036d151186783b66860ee9ff5d98155a08220e4ba9faf565b8ae5595c9abf96a634103ecbc33b4fee936281fc9d5f9c6730311b496ca3f69b920a688127fdbdd83c6c1094ad2ad575c49fc34f9e67a0565b11e2bbb8ad9fc0c27aaaa458eb06dbb5cdd",
      ),
    ];

    final validBytes = commitmentSetBytes(commitBytes);

    late List<DkgCommitmentPair> pairs;
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
      "0a6136d56c46488b7e51a77e0d07467b430fc586d18cd4d7efe8a7fc4aa0003b",
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
