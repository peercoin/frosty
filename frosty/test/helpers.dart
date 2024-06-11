import 'package:frosty/frosty.dart';
import 'package:frosty/src/helpers/message_exception.dart';
import 'dart:typed_data';
import 'package:test/test.dart';

(List<Identifier>, List<DkgPart1>, DkgCommitmentSet) genPart1() {

  final ids = List.generate(3, (i) => Identifier.fromUint16(1+i));
  final eachPart1 = List.generate(
    3,
    (i) => DkgPart1(
      identifier: ids[i],
      threshold: 2,
      n: 3,
    ),
  );

  final commitmentSet = DkgCommitmentSet([
    for (int j = 0; j < 3; j++) (ids[j], eachPart1[j].public),
  ]);

  return (ids, eachPart1, commitmentSet);

}

void writableObjTests<
  T extends WritableRustObjectWrapper,
  E extends MessageException
>(
  Uint8List validBytes,
  T Function(Uint8List) fromBytes,
  [List<Uint8List> extraInvalid = const [],]
) {

  test("fromBytes valid", () => expect(
      fromBytes(validBytes).toBytes(),
      validBytes,
  ),);

  test("fromBytes invalid", () {
    for (final bytes in [
      Uint8List(0),
      Uint8List.view(validBytes.buffer, 1),
      Uint8List.fromList([...validBytes, 0]),
      ...extraInvalid,
    ]) {
      expect(() => fromBytes(bytes), throwsA(isA<E>()));
    }
  });

  test("cannot use after free", () {
    final obj = fromBytes(validBytes);
    obj.dispose();
    expect(() => obj.toBytes(), throwsA(isA<UseAfterFree>()));
  });

}

Uint8List commitmentSetBytes(
  List<Uint8List> commitBytes,
) => Uint8List.fromList([
  3, 0,
  ...Uint8List(32)..last=1,
  commitBytes[0].length,
  ...commitBytes[0],
  ...Uint8List(32)..last=2,
  commitBytes[1].length,
  ...commitBytes[1],
  ...Uint8List(32)..last=3,
  commitBytes[2].length,
  ...commitBytes[2],
]);
