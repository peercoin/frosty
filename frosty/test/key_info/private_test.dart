import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "0000000000000000000000000000000000000000000000000000000000000001"
  "${privateSharesHex[0]}";

final tweakedHex
  = "0000000000000000000000000000000000000000000000000000000000000001"
  "${tweakedPrivateShareHex[0]}";

void main() {
  group("PrivateKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      tweakHex: tweakedHex,
      fromReader: (reader) => PrivateKeyInfo.fromReader(reader),
      getValidObj: () => getParticipantInfo(0).private,
    );

  });
}
