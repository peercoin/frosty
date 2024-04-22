import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../../data.dart';
import '../helpers.dart';
import '../aggregate_test.dart' as non_hd;

final validHex = "${chainCodeHex}000000000000000000${non_hd.validHex}";

final hdAggregateInfo = HDAggregateKeyInfo.master(
  group: groupInfo,
  publicShares: publicSharesInfo,
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
      fromReader: (reader) => HDAggregateKeyInfo.fromReader(reader),
      getValidObj: () => hdAggregateInfo,
    );

    test(".derive()", () {
      final newHdAggregate = hdAggregateInfo.derive(0x7fffffff).derive(0);
      expectDerivedGroup(newHdAggregate.group);
      expectDerivedPublicShares(newHdAggregate.publicShares);
    });

  });

}

