import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/helpers/message_exception.dart';

/// Thrown when the message or MAST hash details are invalid
class InvalidSignDetails extends MessageException {
  InvalidSignDetails(super.message);
}

class SignDetails {

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

}
