import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';

abstract class KeyInfo with Writable {
  KeyInfo? tweak(Uint8List scalar);
}
