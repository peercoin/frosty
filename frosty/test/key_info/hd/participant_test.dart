import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../../data.dart';
import '../helpers.dart';
import '../participant_test.dart' as non_hd;

final validHex = "${chainCodeHex}000000000000000000${non_hd.validHex}";

final hdParticipantInfo = HDParticipantKeyInfo.master(
  group: groupInfo,
  publicShares: publicSharesInfo,
  private: getParticipantInfo(0).signing.private,
);

// Just the participant info
final zeroTweakedHex = non_hd.validHex;
final tweakedHex = non_hd.tweakedHex;

void main() {

  group("HDParticipantKeyInfo", () {

    setUpAll(loadFrosty);

    basicInfoTests(
      validHex: validHex,
      zeroTweakedHex: zeroTweakedHex,
      tweakedHex: tweakedHex,
      invalidTweakHex: invalidGroupTweak,
      fromReader: (reader) => HDParticipantKeyInfo.fromReader(reader),
      getValidObj: () => hdParticipantInfo,
    );

    test(".derive()", () {
      final newHdParticipant = hdParticipantInfo.derive(0x7fffffff).derive(0);
      expectDerivedGroup(newHdParticipant.group);
      expectDerivedPublicShares(newHdParticipant.publicShares);
      expectDerivedPrivate(newHdParticipant.private);
    });

  });

}
