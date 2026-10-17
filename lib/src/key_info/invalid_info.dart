import 'package:frosty/src/helpers/message_exception.dart';

/// Thrown if the FROST key information is not valid
class InvalidKeyInfo extends MessageException {
  InvalidKeyInfo(super.message);
}
