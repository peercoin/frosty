import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:frosty/src/helpers/message_exception.dart';

/// Thrown when the message or MAST hash details are invalid
class InvalidSignDetails extends MessageException {
  InvalidSignDetails(super.message);
}

class SignDetails {

  /// The message to sign
  final Uint8List message;
  /// The 32-byte hash of the MAST tree, or an empty list if omitted
  final Uint8List mastHash;

  /// The message should be agreed upon and for Peercoin transactions is the
  /// taproot signature hash. The [mastHash] can be used when there is a MAST
  /// tree as part of the taproot key, otherwise it should be omitted.
  SignDetails({
    required this.message,
    Uint8List? mastHash,
  }) : mastHash = mastHash ?? Uint8List(0) {

    if (message.length != 32) {
      throw InvalidSignDetails("The message to sign must be 32 bytes");
    }

    if (mastHash != null && mastHash.length != 32) {
      throw InvalidSignDetails("MAST root hash must be 32 bytes or omitted");
    }

  }

}
