import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';

void main() async {
  await loadFrosty();
  final id = bytesToHex(Identifier.fromString("hello").toBytes());
  print("Example Identifier = $id");
}
