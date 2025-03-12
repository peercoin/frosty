import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';

final otherKey = cl.ECPrivateKey(Uint8List(32)..last = 1);
final key1 = cl.ECPrivateKey(Uint8List(32)..last = 2);
final key2 = cl.ECPrivateKey(Uint8List(32)..last = 3);

void main() {
  group("ECCiphertext", () {

    setUpAll(loadFrosty);

    test("can encrypt and decrypt", () {

      void expectValid(Uint8List data) {

        void expectDecrypts(ECCiphertext ct) => expect(
          cl.bytesToHex(ct.decrypt(recipientKey: key2, senderKey: key1.pubkey)!),
          cl.bytesToHex(data),
        );

        final ciphertext = ECCiphertext.encrypt(
          plaintext: data,
          recipientKey: key2.pubkey,
          senderKey: key1,
        );

        // Expect decryption before and after re-serialisation
        expectDecrypts(ciphertext);
        expectDecrypts(
          ECCiphertext.fromReader(cl.BytesReader(ciphertext.toBytes())),
        );

      }

      expectValid(Uint8List(1));
      Uint8List genN(int i) => Uint8List.fromList(
        List.generate(32, (i) => i & 0xff),
      );
      expectValid(genN(32));
      expectValid(genN(33));
      expectValid(genN(2000));

    });

    test(
      "cannot encrypt empty data",
      () => expect(
        () => ECCiphertext.encrypt(
          plaintext: Uint8List(0),
          recipientKey: key2.pubkey,
          senderKey: key1,
        ),
        throwsArgumentError,
      ),
    );

    final iv = "6108a5db7ebc35d530f9fb44";

    final plaintext =
      "74686520717569636b2062726f776e20666f78206a756d7073206f76657220746865206c617a7920646f67";

    final ciphertextBytes = cl.hexToBytes(
      // IV
      "$iv"
      // Length of ciphertext and tag
      "40"
      // Ciphertext
      "e97196860c635a25dbe726d97ab50d0fccfff8b6de7e0a7f9bb93462adf688ead100d5bc6a69e87b7bc9d50a6f4c05f3"
      // Tag
      "ea79a62c66b5a8b5fc177c409fdbff06",
    );

    final fullBlockPlaintext = "000102030405060708090a0b0c0d0e0f";
    final fullBlockCiphertextBytes = cl.hexToBytes(
      // IV
      "e7da23614842d672648d87ff"
      // Length of ciphertext and tag
      "30"
      // Ciphertext
      "9596476c2096e72c23b4346b541f339575a3efd83f875c4374f2e125f4461f2c"
      // Tag
      "3fa97811a74c18fa758bfbadb87b0660",
    );

    test("decrypts from data", () {

      void expectDecrypts(Uint8List ciphertext, String plaintext) => expect(
        cl.bytesToHex(
          ECCiphertext.fromReader(cl.BytesReader(ciphertext))
          .decrypt(recipientKey: key2, senderKey: key1.pubkey)!,
        ),
        plaintext,
      );

      expectDecrypts(ciphertextBytes, plaintext);
      expectDecrypts(fullBlockCiphertextBytes, fullBlockPlaintext);

    });

    test("fails when unauthenticated or corrupted", () {

      void expectInvalid(Uint8List ciphertext, cl.ECPublicKey senderKey) => expect(
        ECCiphertext.fromReader(cl.BytesReader(ciphertext)).decrypt(
          recipientKey: key2,
          // Different sender
          senderKey: senderKey,
        ),
        null,
      );

      void expectDiffByte(int i)
        => expectInvalid(ciphertextBytes.sublist(0)..[i] ^= 0xff, key1.pubkey);

      void expectArgumentError(Uint8List ciphertext) => expect(
        () => ECCiphertext.fromReader(cl.BytesReader(ciphertext)),
        throwsArgumentError,
      );

      // Wrong key
      expectInvalid(ciphertextBytes, otherKey.pubkey);

      // Wrong IV
      expectDiffByte(0);

      // Wrong ciphertext
      expectDiffByte(15);

      // Wrong tag
      expectDiffByte(ciphertextBytes.length-1);

      // Wrong size
      expectArgumentError(
        cl.hexToBytes(
          "$iv"
          "41"
          "e97196860c635a25dbe726d97ab50d0fccfff8b6de7e0a7f9bb93462adf688ead100d5bc6a69e87b7bc9d5096c4f06f00c"
          "7406fa67aa9436b5eff99b4a7d1adb8e",
        ),
      );

      // Empty
      expectArgumentError(cl.hexToBytes("${iv}00"));

      // Wrong padding: contains incorrect byte
      expectInvalid(
        cl.hexToBytes(
          "$iv"
          "40"
          "e97196860c635a25dbe726d97ab50d0fccfff8b6de7e0a7f9bb93462adf688ead100d5bc6a69e87b7bc9d5096f4c05f3"
          "e9e16cd88cc31ad5238dd1a66c30ec42",
        ),
        key1.pubkey,
      );

      // Wrong padding: pad size too long
      expectInvalid(
        cl.hexToBytes(
          "$iv"
          "50"
          "e97196860c635a25dbe726d97ab50d0fccfff8b6de7e0a7f9bb93462adf688ead100d5bc6a69e87b7bc9d51a7f5c15e31fd9e3cd0719415fb6a2e6ea0563ab8a"
          "d0e07dc8dd121cb515a51377b8bf66d7",
        ),
        key1.pubkey,
      );

      // Wrong padding: zero pad
      expectInvalid(
        cl.hexToBytes(
          "$iv"
          "40"
          "e97196860c635a25dbe726d97ab50d0fccfff8b6de7e0a7f9bb93462adf688ead100d5bc6a69e87b7bc9d50f6a4900f6"
          "63e266692ffb997a4e3432f399803efd",
        ),
        key1.pubkey,
      );

    });

  });
}
