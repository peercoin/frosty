import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;

abstract class KeyInfo with cl.Writable {
  KeyInfo? tweak(Uint8List scalar);
}
