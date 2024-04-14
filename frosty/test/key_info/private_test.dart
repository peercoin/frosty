import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex =
"0000000000000000000000000000000000000000000000000000000000000001bafe4fab41fee3ca118cce1af9c2432189030d0e0249365787b8e71da37fdbb3";

void main() {
  group("PrivateKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      name: "private",
      validHex: validHex,
      fromReader: (reader) => PrivateKeyInfo.fromReader(reader),
      getValidObj: () => getParticipantInfo(0).private,
    );

  });
}
