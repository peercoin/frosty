import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import '../helpers.dart';

void main() {
  group("DkgPublicCommitment", () {

    setUpAll(loadFrosty);

    final validBytes = cl.hexToBytes(
      "00230f8ab3020389ae0c08ebcd4ba00d64164b24a8e24ebadeadb782b8442d173aab6717bb910103c852b1505ab3c1a4c105ad3187b309313522d1b1af6b868fd200b6d14990bd4140b7092c6e1e762a0afa4eeb01636098b209b940c953e9d83b050e73c2d4ce133d6093ddb2bf7c05b2df0301eb3e6c443f10f21b88b762ab8586b930d7325a448b",
    );

    writableRustObjTests<DkgPublicCommitment, InvalidPublicCommitment>(
      validBytes,
      (b) => DkgPublicCommitment.fromBytes(b),
      [Uint8List.fromList(validBytes.toList())..first = 10],
    );

  });
}
