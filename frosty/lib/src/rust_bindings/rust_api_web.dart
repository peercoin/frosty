import 'dart:typed_data';

final _err = UnimplementedError("Web support is not yet available");

class FrostIdentifier {}

class DummyApi {
  FrostIdentifier identifierFromString({required String s, dynamic hint}) {
    throw _err;
  }
  FrostIdentifier identifierFromU16({required int i, dynamic hint}) {
    throw _err;
  }
  FrostIdentifier identifierFromBytes({
    required Uint8List bytes, dynamic hint,
  }) {
    throw _err;
  }
  Uint8List identifierToBytes({
    required FrostIdentifier identifier, dynamic hint,
  }) {
    throw _err;
  }
}

final rustApi = DummyApi();

Future<void> loadFrostyImpl() async => throw _err;
