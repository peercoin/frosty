import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("SigningCommitmentSet", () {

    final commitBytes = [
      hexToBytes(
        "00230f8ab302de8e5cc1582be4b6b5a1e8be2d482dabe86d2e3368d1a98785fb27bfcdfdf72902ec04d9f8bb9b423927defe454295d07e0609c029f6c6778a218fe9d575c125d9",
      ),
      hexToBytes(
        "00230f8ab3034a5c56a0fdfd189fc935331f0008a16d61c3db5998ebede1d9f0b6456b39e17003d2f3c070a138ab58de07013876e50cc2f05bef6681d8eb055980bff46c373767",
      ),
      hexToBytes(
        "00230f8ab3031b9d1998b16dcc78ffc41c5220b991e648a559eb8138e56a40657f40a7a51ee10236ca4c26344e002d8633ebf45f57fe44861d7407eb1db4f346e62967c7911341",
      ),
    ];

    final validBytes = commitmentSetBytes(commitBytes);

    late List<SigningCommitmentPair> pairs;
    setUpAll(() async {
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
