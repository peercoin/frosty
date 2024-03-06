import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("SigningCommitmentSet", () {

    final commitBytes = [
      hexToBytes(
        "03fdf5d27e42f268ba31ac9897314648c135dfb69f9c1700b89df9adb4c84c0614024bcd50c429aa3e50b4d98dd90cb8c421520d57f34a5f604de50e36361ce21636f49d8cce",
      ),
      hexToBytes(
        "034bdf042fec84d256ecb7233bd2bddc454f5d32804a3a28269e9e032c840a849c039e873ae0a55ade059706207da8f613b37da000074e888d23f5ca00c82713418ff49d8cce",
      ),
      hexToBytes(
        "027b951234a3f3fe165e58b3b3ea25d26eb38d6c484bb70f08920b1c3ab361e64c03ecd9b8042e3a5cc8d0e7c0939a900d5c0178a0b0098e3aabad9697d6f74e2001f49d8cce",
      ),
    ];

    final validBytes = commitmentSetBytes(commitBytes);

    late List<SigningCommitmentPair> pairs;
    setUp(() async {
      await loadFrosty();
      pairs = List.generate(
        3,
        (i) => (
          Identifier.fromUint16(i+1),
          SigningCommitment.fromBytes(commitBytes[i]),
        ),
      );
    });

    test("valid bytes", () {
      final commitments = SigningCommitmentSet.fromReader(BytesReader(validBytes));
      expect(commitments.toHex(), bytesToHex(validBytes));
      final fromPairs = SigningCommitmentSet(pairs);
      expect(fromPairs.toHex(), bytesToHex(validBytes));
    });

    test("invalid bytes", () {

      void expectThrows<T>(Uint8List invalid) => expect(
        () => SigningCommitmentSet.fromReader(BytesReader(invalid)),
        throwsA(isA<T>()),
      );

      expectThrows<OutOfData>(Uint8List(0));
      expectThrows<InvalidSigningCommitment>(
        Uint8List.fromList(List.from(validBytes)..removeAt(1)),
      );

    });

  });
}
