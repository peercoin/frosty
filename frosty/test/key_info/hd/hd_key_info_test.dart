import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../../data.dart';

final validHex = "${chainCodeHex}000000000000000000";

void main() {

  group("HDKeyInfo", () {

    late HDKeyInfo hdInfo;
    setUpAll(() async {
      await loadFrosty();
      hdInfo = HDKeyInfo.fromReader(BytesReader(hexToBytes(validHex)));
    });

    test("invalid parameters", () {

      void expectInvalid({
        Uint8List? cc,
        int depth = 0,
        int index = 0,
        int fingerprint = 0,
      }) => expect(
        () => HDKeyInfo(
          chaincode: cc ?? Uint8List(32),
          depth: depth,
          index: index,
          parentFingerprint: fingerprint,
        ),
        throwsArgumentError,
      );

      expectInvalid(cc: Uint8List(31));
      expectInvalid(cc: Uint8List(33));
      expectInvalid(depth: -1);
      expectInvalid(depth: 0x100);
      expectInvalid(index: -1);
      expectInvalid(index: HDKey.hardenBit);
      expectInvalid(fingerprint: -1);
      expectInvalid(fingerprint: 0x100000000);

    });

    test("valid bytes", () {
      expect(bytesToHex(hdInfo.chaincode), chainCodeHex);
      expect(hdInfo.depth, 0);
      expect(hdInfo.index, 0);
      expect(hdInfo.parentFingerprint, 0);
    });

    test("invalid bytes", () {
      expect(
        () => HDKeyInfo.fromReader(
          BytesReader(hexToBytes("${chainCodeHex}000000008000000000")),
        ),
        throwsArgumentError,
      );
    });

    group(".deriveTweakAndInfo bytes", () {

      test("invalid index", () {
        void expectError(int index) => expect(
          () => hdInfo.deriveTweakAndInfo(groupPublicKey, index),
          throwsArgumentError,
        );
        expectError(-1);
        expectError(HDKey.hardenBit);
      });

      test("provides correct info and tweak", () {
        final (tweak, newInfo) = hdInfo.deriveTweakAndInfo(groupPublicKey, 0x7fffffff);
        expect(
          bytesToHex(tweak),
          "906127eab0867c7892e0354960914b759df12ba019bf11f8b97d4d1f6e9f4edb",
        );
        expect(
          bytesToHex(newInfo.chaincode),
          "a841d1c10b5de192916226333c5bef3fef9c789d3a14cc0231961c8fcadc893e",
        );
        expect(newInfo.depth, 1);
        expect(newInfo.index, 0x7fffffff);
        expect(newInfo.parentFingerprint, 0x2b0dfb83);
      });

    });

  });

}
