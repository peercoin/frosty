import 'package:frosty/frosty.dart';

(List<Identifier>, List<DkgPart1>, List<DkgCommitmentSet>) genPart1() {

  final ids = List.generate(3, (i) => Identifier.fromUint16(1+i));
  final eachPart1 = List.generate(
    3,
    (i) => DkgPart1(
      identifier: ids[i],
      threshold: 2,
      n: 3,
    ),
  );

  final eachCommitmentSet = List.generate(
    3,
    (i) => DkgCommitmentSet([
      for (int j = 0; j < 3; j++)
      if (j != i) (ids[j], eachPart1[j].public),
    ]),
  );

  return (ids, eachPart1, eachCommitmentSet);

}
