import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

final testIdHex
  = "42c9baf42b1cdefb007e286c44a4b9f23430b99f0f038447619c2ce111e737f4";

void main() {
  group("Identifier", () {

    setUp(loadFrosty);

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
        "df3674e99032636afb6c921a413efe58d6848743bd1957fedb585d97416f60da",
      );
    });

    test("fromBytes valid", () {
      final bytes = hexToBytes(testIdHex);
      expect(
        bytesToHex(Identifier.fromBytes(bytes).toBytes()),
        testIdHex,
      );
    });

    test("fromUint16 invalid", () {
      for (final bad in [0, 0x10000]) {
        expect(() => Identifier.fromUint16(bad), throwsA(isA<InvalidIdentifier>()));
      }
    });

    test("fromBytes invalid", () {
      for (final bad in [
        // Zero
        "0000000000000000000000000000000000000000000000000000000000000000",
        // Out of field order
        "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141",
        // Too small
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e",
        // Too large
        "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20",
      ]) {
        expect(
          () => Identifier.fromBytes(hexToBytes(bad)),
          throwsA(isA<InvalidIdentifier>()),
        );
      }
    });

    test("allows equality comparison", () {
      final id1 = Identifier.fromUint16(1);
      final id2 = Identifier.fromUint16(2);
      expect(id1, id1);
      expect(id1, Identifier.fromUint16(1));
      expect(id1, isNot(id2));
    });

  });
}
