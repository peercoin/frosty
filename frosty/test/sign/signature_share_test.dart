import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("SignatureShare", () {

    setUpAll(loadFrosty);

    final validBytes = cl.hexToBytes(
      "84ee1adfe96d4670fc6fcf5def51bbfa886389f5bdb2e9b3ccf91824324e613c",
    );

    writableRustObjTests<SignatureShare, InvalidSignatureShare>(
      validBytes,
      (b) => SignatureShare.fromBytes(b),
    );

  });
}
