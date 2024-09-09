import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../../data.dart';
import '../helpers.dart';

final validHex = "${chainCodeHex}000000000000000000${groupPublicKeyHex}0200";

final hdGroupInfo = HDGroupKeyInfo.master(
  groupKey: groupPublicKey,
  threshold: 2,
);

// Just the group info
final zeroTweakedHex = "${groupPublicKeyHex}0200";
final tweakedHex = "${tweakedGroupKeyHex}0200";

void main() {

  group("HDGroupKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      zeroTweakedHex: zeroTweakedHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromHex: (hex) => HDGroupKeyInfo.fromHex(hex),
      getValidObj: () => hdGroupInfo,
    );

    test(".derive()", () => expectDerivedGroup(
      hdGroupInfo.derive(0x7fffffff).derive(0),
    ),);

  });

}
