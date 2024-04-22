import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../../data.dart';
import '../helpers.dart';
import '../signing_test.dart' as non_hd;

final validHex = "${chainCodeHex}000000000000000000${non_hd.validHex}";

final hdSigningInfo = HDSigningKeyInfo.master(
  group: groupInfo,
  private: getParticipantInfo(0).signing.private,
);

// Just the signing info
final zeroTweakedHex = non_hd.validHex;
final tweakedHex = non_hd.tweakedHex;

void main() {

  group("HDSigningKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      zeroTweakedHex: zeroTweakedHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromReader: (reader) => HDSigningKeyInfo.fromReader(reader),
      getValidObj: () => hdSigningInfo,
    );

    test(".derive()", () {
      final newHdSigning = hdSigningInfo.derive(0x7fffffff).derive(0);
      expectDerivedGroup(newHdSigning.group);
      expectDerivedPrivate(newHdSigning.private);
    });

  });

}
