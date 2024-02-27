import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

/// Exception for when a valid Rust object cannot be created
class InvalidObject implements Exception {
  final String error;
  InvalidObject(this.error);
  @override
  String toString() => "$runtimeType: $error";
}

/// Runs [f] to obtain a Rust object. If there is an [FrbAnyhowException] throws
/// the exception given by [toE] which is passed the anyhow messsage.
Obj handleGetObject<Obj>(
  Obj Function() f,
  Exception Function(String) toE,
) {
  try {
    return f();
  } on FrbAnyhowException catch(e) {
    throw toE(e.anyhow);
  }
}

