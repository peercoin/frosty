import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

/// Runs [f] to obtain a Rust object. If there is an [AnyhowException] throws
/// the exception given by [toE] which is passed the anyhow messsage.
Obj handleGetObject<Obj>(
  Obj Function() f,
  Exception Function(String) toE,
) {
  try {
    return f();
  } on AnyhowException catch(e) {
    throw toE(e.message);
  }
}

