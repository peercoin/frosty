import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

final tweak = hexToBytes(
  "2bfe58ab6d9fd575bdc3a624e4825dd2b375d64ac033fbc46ea79dbab4f69a3e",
);

void basicInfoTests<T extends KeyInfo>({
  required String validHex,
  String? zeroTweakedHex,
  required String tweakedHex,
  required String invalidTweakHex,
  required T Function(BytesReader reader) fromReader,
  required T Function() getValidObj,
}) {

    test("valid info", () {
      expect(getValidObj().toHex(), validHex);
      expect(
        fromReader(BytesReader(hexToBytes(validHex))).toHex(),
        validHex,
      );
    });

    test("tweaks as expected", () {
      expect(getValidObj().tweak(tweak)!.toHex(), tweakedHex);
      expect(getValidObj().tweak(Uint8List(32))!.toHex(), zeroTweakedHex ?? validHex);
    });

    test(
      "invalid tweak",
      () => expect(getValidObj().tweak(hexToBytes(invalidTweakHex)), null),
    );

    test("invalid info bytes", () => expect(
        () => fromReader(BytesReader(Uint8List(0))),
        throwsA(isA<OutOfData>()),
    ),);

}

void expectDerivedGroup(GroupKeyInfo group) {
  expect(
    group.publicKey.hex,
    "0376c43ce6ecba9bbf792bde40877b47a0c7cbd8acce9af05efc3e3d8b6725f98e",
  );
  expect(group.threshold, 2);
}

void expectDerivedPublicShares(PublicSharesKeyInfo public) => expect(
  public.list.map((e) => e.$2.hex).toList(),
  [
    "02706a5f14dde3a0d9ac9ec1b678077f4f638b1428b78b0daeb544e2a40fade0b5",
    "03f25232cfb18a16b9c258cd3ff4a085d03156fd80fe8e7c60d6ab99e371903c5f",
    "0259a7f6b865cb7649851a2748520c191ae3708b9228ee444a03a46b42c76a0280",
  ],
);

void expectDerivedPrivate(PrivateKeyInfo private) => expect(
  bytesToHex(private.share.data),
  "3ea033c6902135150ff71e0fdf47e525186a0aa5c15717474709016a35b3f10d",
);
