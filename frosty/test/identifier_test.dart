import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import 'helpers.dart';

final testIdHex
  = "d10672c45e416c0e096ca08686e3f5226d3d7ed8fcc2d758624e396445bfdb9f";

void main() {
  group("Identifier", () {

    setUpAll(loadFrosty);

    writableRustObjTests<Identifier, InvalidIdentifier>(
      hexToBytes(testIdHex),
      (b) => Identifier.fromBytes(b),
      [
        // Zero
        "0000000000000000000000000000000000000000000000000000000000000000",
        // Out of field order
        "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141",
        // Too small
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e",
        // Too large
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20",
      ].map((hex) => hexToBytes(hex)).toList(),
    );

    test("fromUint16 valid", () {
      expect(
        Identifier.fromUint16(1).toBytes(),
        Uint8List(32)..last = 1,
      );
      expect(
        Identifier.fromUint16(0xfffd).toBytes(),
        Uint8List(32)
        ..last = 0xfd
        ..[30] = 0xff,
      );
    });

    test("fromString valid", () {
      expect(
        bytesToHex(Identifier.fromString("test").toBytes()),
        testIdHex,
      );
      expect(
        bytesToHex(Identifier.fromString("TEST").toBytes()),
        "5d7a4e95f0c8bfc95cd7d834354cca30a94106a33701b621ad37f68636a7e654",
      );
    });

    test("fromUint16 invalid", () {
      for (final bad in [0, 0x10000]) {
        expect(() => Identifier.fromUint16(bad), throwsA(isA<InvalidIdentifier>()));
      }
    });

    test("allows equality comparison", () {
      final id1 = Identifier.fromUint16(1);
      final id2 = Identifier.fromUint16(2);
      expect(id1, id1);
      expect(id1, Identifier.fromUint16(1));
      expect(id1, isNot(id2));
    });

    test("allows comparison", () {
      final id1 = Identifier.fromUint16(1);
      final id2 = Identifier.fromUint16(2);
      final id3 = Identifier.fromUint16(3);
      final idffff = Identifier.fromUint16(0xffff);
      expect(
        [id2, idffff, id1, id3]..sort(),
        orderedEquals([id1, id2, id3, idffff]),
      );
    });

  });
}
