/// Exception with a message given by [toString].
class MessageException implements Exception {
  final String message;
  MessageException(this.message);
  @override
  String toString() => "$runtimeType: $message";
}
