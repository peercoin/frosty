import 'package:coinlib/coinlib.dart';
import 'package:frosty/frosty.dart';
import 'package:test/test.dart';
import 'helpers.dart';

void main() {
  group("PrivateKeyShare", () {

    setUp(loadFrosty);

    final validBytes = hexToBytes(
      "00000000000000000000000000000000000000000000000000000000000000010f0db9a2f6e86f48c568b78ff89d264e6bd774694411d736d84f7099b7a6ed4002370f7ad7bfad7ef79fea645bca90e33f9791534fcc8f685756a2ec92584c4a65038e49bb229231f3de9ffd9120441ecd708158df4e74bb717302765ab0720b5d2002f49d8cce",
    );

    writableObjTests<PrivateKeyShare, InvalidPrivateKeyShare>(
      validBytes,
      (b) => PrivateKeyShare.fromBytes(b),
    );

  });
}
