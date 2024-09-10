import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/src/helpers/message_exception.dart';

/// Thrown when the message or MAST hash details are invalid
class InvalidSignDetails extends MessageException {
  InvalidSignDetails(super.message);
}

class SignDetails with Writable {

  /// The message to sign
  final Uint8List message;
  /// The 32-byte hash of the MAST tree. This can be set to an empty list if a
  /// proof of an empty MAST tree is required, or null to avoid needing to tweak
  /// the internal Taproot key or when signing with a key in a Tapscript.
  final Uint8List? mastHash;

  /// The [message] should be agreed upon and for Peercoin transactions is the
  /// taproot signature hash.
  ///
  /// The [mastHash] should contain the root hash of the MAST tree. If null, no
  /// Taproot tweak will be used. If an empty list, a tweak without the MAST
  /// hash will be used.
  SignDetails({
    required this.message,
    required this.mastHash,
  }) {

    if (message.length != 32) {
      throw InvalidSignDetails("The message to sign must be 32 bytes");
    }

    if (mastHash != null && mastHash!.length != 32 && mastHash!.isNotEmpty) {
      throw InvalidSignDetails("MAST root hash must be 32 bytes, empty or omitted");
    }

  }

  factory SignDetails.fromReader(BytesReader reader) {
    final msg = reader.readSlice(32);
    final mastType = reader.readUInt8();
    if (mastType > 2) throw InvalidSignDetails("Invalid MAST specifier byte");
    return SignDetails(
      message: msg,
      mastHash: mastType == 0
        ? null
        : (mastType == 1 ? Uint8List(0) : reader.readSlice(32)),
    );
  }

  /// Convenience constructor to construct from serialised [bytes].
  factory SignDetails.fromBytes(Uint8List bytes)
    => SignDetails.fromReader(BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  factory SignDetails.fromHex(String hex)
    => SignDetails.fromBytes(hexToBytes(hex));

  /// Used for key-spend signatures. This will always tweak the internal key. If
  /// there is no MAST root hash provided, the tweak will be done without a
  /// MAST hash for Taproot programs that only have a key-path.
  SignDetails.keySpend({
    required Uint8List message,
    Uint8List? mastHash,
  }) : this(message: message, mastHash: mastHash ?? Uint8List(0));

  /// Used for script-spend signatures. This does not tweak the key allowing for
  /// direct signing with a key specified in a Tapscript.
  SignDetails.scriptSpend({ required Uint8List message })
    : this(message: message, mastHash: null);

  @override
  void write(Writer writer) {

    final mastType = mastHash == null
      ? 0
      : (mastHash!.isEmpty ? 1 : 2);

    writer.writeSlice(message);
    writer.writeUInt8(mastType);
    if (mastType == 2) writer.writeSlice(mastHash!);

  }

}
