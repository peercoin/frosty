import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgShareToGive", () {

    setUp(loadFrosty);

    final validBytes = hexToBytes(
      "a3ee9514c0c431a4fc8eb815f2e472d389e60c86692398a7ff9e20d57a33a6cef49d8cce",
    );

    writableObjTests<DkgShareToGive, InvalidShareToGive>(
      validBytes,
      (b) => DkgShareToGive.fromBytes(b),
    );

  });
}
