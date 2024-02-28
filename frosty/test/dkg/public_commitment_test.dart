import 'dart:typed_data';
import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgPublicCommitment", () {

    setUp(loadFrosty);

    final validBytes = hexToBytes(
      "020274a9be4c28750cd77e907a93897ab0d064a7afcf8436ce876b6fd48cc7b733fc0315791be9ab148c8bfb951f9e9b68c2f00ac5173273741bcd1bd6a547063e266741030182de188fe8d4db6b86f5a0c6fd197c3d7fc394957f8bc13cd6afcfa4ef6e2b40e2cdf4948494314fe8ba4dae8dd9200e147825cc9889cea922882ee870f799f49d8cce",
    );

    writableObjTests<DkgPublicCommitment, InvalidPublicCommitment>(
      validBytes,
      (b) => DkgPublicCommitment.fromBytes(b),
      [Uint8List.fromList(validBytes.toList())..first = 10],
    );

  });
}
