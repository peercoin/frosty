import 'package:frosty/frosty.dart';
import 'package:frosty/src/frosty_base.dart';
import 'package:test/test.dart';
import '../data.dart';
import 'helpers.dart';

final validHex
  = "027f2b9f6b67de76a624c750226221a73f79280d91f3e14b42e0994950605804b202000000000000000000000000000000000000000000000000000000000000000001bafe4fab41fee3ca118cce1af9c2432189030d0e0249365787b8e71da37fdbb3";

void main() {
  group("SigningKeyInfo", () {

    setUp(loadFrosty);

    basicInfoTests(
      name: "signing",
      validHex: validHex,
      fromReader: (reader) => SigningKeyInfo.fromReader(reader),
      // Test getting from ParticipantKeyInfo
      getValidObj: () => getParticipantInfo(0).signing,
    );

  });
}
