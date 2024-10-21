import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("SigningNonces", () {

    setUpAll(loadFrosty);

    final validBytes = hexToBytes(
      "00230f8ab3121d5ea9e9c85db66944cf0b4ae7ee2b3188aee1048f928339b8676e835d23907e9b6c57a0c393e3265763cc74cad50da1b8ec084f50cedc42a79ec7eb040f1f00230f8ab303810d26bf4ba54aef843da0a3f0b1b5d7b5815bd48f679af8511ede6af126106e03dafa5bf5778e74cfd53ea14090de7441fd8f086f9e0bb371a114ca4a1e537c1c",
    );

    writableRustObjTests<SigningNonces, InvalidSigningNonces>(
      validBytes,
      (b) => SigningNonces.fromBytes(b),
    );

  });
}
