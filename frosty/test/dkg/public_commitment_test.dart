import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgPublicCommitment", () {

    setUpAll(loadFrosty);

    final validBytes = hexToBytes(
      "00230f8ab30203c08d0599e8c604df77fb36266698ca5aa06e7cdddfa31e50074995afc0e543ba02b1f1567a0819837772d3c88e8419ee3d422deca8fd3d81b6507a97c0e70f9b684103b1e8c505225aefd1d7cb1dd4363f455e82d78d2099a8df977699f25832e0a11d9ff140ee435c9df7d019a2e589a752475e9a3153bfcb921bf7a83420f737a302",
    );

    writableRustObjTests<DkgPublicCommitment, InvalidPublicCommitment>(
      validBytes,
      (b) => DkgPublicCommitment.fromBytes(b),
      [Uint8List.fromList(validBytes.toList())..first = 10],
    );

  });
}
