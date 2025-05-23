import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgShareToGive", () {

    setUpAll(loadFrosty);

    final validBytes = cl.hexToBytes(
      "00230f8ab3086cb9f7c5e975af7c925ae4fef5e2a7291e877cf2e54a8c64abc4d6994ced23",
    );

    writableRustObjTests<DkgShareToGive, InvalidShareToGive>(
      validBytes,
      (b) => DkgShareToGive.fromBytes(b),
    );

  });
}
