import 'dart:typed_data';

final _err = UnimplementedError("Web support is not yet available");

class FrostIdentifier {}
class DkgRound1SecretPackage {}
class DkgRound1Package {}

class DummyApi {

  FrostIdentifier identifierFromString({
    required String s, dynamic hint,
  }) { throw _err; }

  FrostIdentifier identifierFromU16({
    required int i, dynamic hint,
  }) { throw _err; }

  FrostIdentifier identifierFromBytes({
    required Uint8List bytes, dynamic hint,
  }) { throw _err; }

  Uint8List identifierToBytes({
    required FrostIdentifier identifier, dynamic hint,
  }) { throw _err; }

  (DkgRound1SecretPackage, DkgRound1Package) dkgPart1({
    required FrostIdentifier identifier,
    required int maxSigners,
    required int minSigners,
    dynamic hint,
  }) { throw _err; }

  DkgRound1Package publicCommitmentFromBytes({
    required Uint8List bytes, dynamic hint,
  }) { throw _err; }

  Uint8List publicCommitmentToBytes({
    required DkgRound1Package commitment, dynamic hint,
  }) { throw _err; }

}

final rustApi = DummyApi();

Future<void> loadFrostyImpl() async => throw _err;
