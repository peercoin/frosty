import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/identifier.dart';
import 'key_info_with_group_key.dart';
import 'package:frosty/src/rust_bindings/rust_api.dart' as rust;
import 'invalid_info.dart';
import 'group.dart';
import 'public_shares.dart';

typedef PrivateShareList = List<(Identifier, cl.ECPrivateKey)>;
class InvalidShares implements Exception {}

/// Contains the group details and public shares used to aggregate a signature
/// from shares.
class AggregateKeyInfo extends KeyInfoWithGroupKey {

  final GroupKeyInfo group;
  final PublicSharesKeyInfo publicShares;

  static void validateGroupWithPublicShares(
    GroupKeyInfo group, PublicSharesKeyInfo publicShares,
  ) {
    if (group.threshold > publicShares.list.length) {
      throw InvalidKeyInfo(
        "threshold shouldn't exceed ${publicShares.list.length}",
      );
    }
  }

  AggregateKeyInfo({
    required this.group,
    required this.publicShares,
  }) {
    validateGroupWithPublicShares(group, publicShares);
  }

  AggregateKeyInfo.fromReader(cl.BytesReader reader) : this(
    group: GroupKeyInfo.fromReader(reader),
    publicShares: PublicSharesKeyInfo.fromReader(reader),
  );

  /// Convenience constructor to construct from serialised [bytes].
  AggregateKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  AggregateKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    group.write(writer);
    publicShares.write(writer);
  }

  @override
  /// Tweaks the aggregate key info by a scalar. null may be returned if the
  /// scalar was crafted to lead to an invalid key or shares.
  AggregateKeyInfo? tweak(Uint8List scalar) {
    final newGroup = group.tweak(scalar);
    final newShares = publicShares.tweak(scalar);
    return newGroup == null || newShares == null
      ? null
      : AggregateKeyInfo(group: newGroup, publicShares: newShares);
  }

  /// Constructs the private key of the FROST key using a threshold number of
  /// private shares with the identifiers and associated private key shares.
  ///
  /// Throws [InvalidShares] if the provided shares do not provide the correct
  /// private key that matches the group public key.
  ///
  /// To avoid [InvalidShares] being thrown, it can be checked that a private
  /// share matches the public share before it is included in the
  /// [privateShares] list.
  cl.ECPrivateKey constructPrivateKey(PrivateShareList privateShares) {

    if (privateShares.length != group.threshold) {
      throw ArgumentError.value(
        privateShares.length,
        "privateShares.length",
        "not equal to the threshold",
      );
    }

    final privateKey = cl.ECPrivateKey(
      rust.constructPrivateKey(
        privateShares: privateShares.map(
          (share) => rust.IdentifierAndPrivateShare(
            identifier: share.$1.underlying,
            privateShare: share.$2.data,
          ),
        ).toList(),
        groupPk: group.groupKey.data,
        threshold: group.threshold,
      ),
    );

    if (privateKey.pubkey != group.groupKey) throw InvalidShares();

    return privateKey;

  }

  @override
  cl.ECCompressedPublicKey get groupKey => group.groupKey;

}
