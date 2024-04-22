import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("SigningCommitment", () {

    setUpAll(loadFrosty);

    final validBytes = hexToBytes(
      "00230f8ab302de8e5cc1582be4b6b5a1e8be2d482dabe86d2e3368d1a98785fb27bfcdfdf72902ec04d9f8bb9b423927defe454295d07e0609c029f6c6778a218fe9d575c125d9",
    );

    writableObjTests<SigningCommitment, InvalidSigningCommitment>(
      validBytes,
      (b) => SigningCommitment.fromBytes(b),
    );

  });
}
