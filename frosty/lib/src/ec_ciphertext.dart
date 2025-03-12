import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import "rust_bindings/rust_api.dart" as rust;

/// Provides an authenticated ciphertext with asymmetric ECC
/// encryption/decryption.
///
/// This uses ECDH to determine a shared symmetric key between the sender and
/// recipient. The plaintext is encrypted using authenticated AES-GCM. PKCS7
/// padding is used.
class ECCiphertext with cl.Writable {

  static const _ivSizeBytes = 12;
  static const _blockSize = 16;

  late Uint8List _iv;
  late Uint8List _data;

  ECCiphertext.fromReader(cl.BytesReader reader)
    : _iv = reader.readSlice(_ivSizeBytes), _data = reader.readVarSlice() {
    if (_data.isEmpty) {
      throw ArgumentError("Ciphertext is empty");
    }
    if (_data.length  % _blockSize != 0) {
      throw ArgumentError("Ciphertext data doesn't align with block size");
    }
  }
  ECCiphertext.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Encrypts [plaintext] using the private [senderKey] and public
  /// [recipientKey].
  ECCiphertext.encrypt({
    required Uint8List plaintext,
    required cl.ECPublicKey recipientKey,
    required cl.ECPrivateKey senderKey,
  }) {

    if (plaintext.isEmpty) {
      throw ArgumentError.value(plaintext, "plaintext", "is empty");
    }

    // Add PKCS7 padding
    final fullSize = (plaintext.length ~/ _blockSize + 1) * _blockSize;
    final padSize = fullSize - plaintext.length;
    final padded = Uint8List.fromList([
      ...plaintext,
      ...List.filled(padSize, padSize),
    ]);

    // Do encryption
    final result = rust.aesGcmEncrypt(
      key: senderKey.diffieHellman(recipientKey),
      plaintext: padded,
    );

    _iv = result.nonce;
    _data = result.data;

  }

  /// Obtains the plaintext by decrypting with the private [recipientKey] and
  /// public [senderKey].
  ///
  /// Returns null if the ciphertext cannot be decrypted and authenticated.
  Uint8List? decrypt({
    required cl.ECPrivateKey recipientKey,
    required cl.ECPublicKey senderKey,
  }) {

    late final Uint8List decrypted;
    try {
      decrypted = rust.aesGcmDecrypt(
        key: recipientKey.diffieHellman(senderKey),
        ciphertext: rust.AesGcmCiphertext(data: _data, nonce: _iv),
      );
    } on Exception {
      return null;
    }

    // Check and remove PKCS7 padding
    final padSize = decrypted.last;
    final padStart = decrypted.length-padSize;
    if (
      padSize == 0 || padSize > _blockSize
      || decrypted.skip(padStart).any((i) => i != padSize)
    ) {
      return null;
    }

    return decrypted.sublist(0, padStart);

  }

  @override
  void write(cl.Writer writer) {
    writer.writeSlice(_iv);
    writer.writeVarSlice(_data);
  }

}

