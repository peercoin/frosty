import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("SigningCommitment", () {

    setUp(loadFrosty);

    final validBytes = hexToBytes(
      "0236e4add85a835007b52bc49b00bd53baa1587c209b03e5419c9e6d3033b1873e02f270e7862fd54af404a76e0978aa3a80f5056987dc965e9a00c1823562b3390bf49d8cce",
    );

    writableObjTests<SigningCommitment, InvalidSigningCommitment>(
      validBytes,
      (b) => SigningCommitment.fromBytes(b),
    );

  });
}
