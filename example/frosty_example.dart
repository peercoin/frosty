// ignore_for_file: avoid_print

import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';

void main() async {
  await loadFrosty();
  final id = bytesToHex(Identifier.fromSeed("hello").toBytes());
  print("Example Identifier = $id");
}
