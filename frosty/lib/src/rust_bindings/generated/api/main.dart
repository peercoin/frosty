// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.10.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'main.freezed.dart';

// These functions are ignored because they are not marked as `pub`: `construct_signing_package`, `from_bytes`, `get_cipher`, `vec_to_array`, `vector_to_group_key`, `vector_to_signing_share`, `vector_to_verifying_share`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `clone`, `clone`, `clone`, `clone`

IdentifierOpaque identifierFromString({required String s}) =>
    RustLib.instance.api.crateApiMainIdentifierFromString(s: s);

IdentifierOpaque identifierFromU16({required int i}) =>
    RustLib.instance.api.crateApiMainIdentifierFromU16(i: i);

IdentifierOpaque identifierFromBytes({required List<int> bytes}) =>
    RustLib.instance.api.crateApiMainIdentifierFromBytes(bytes: bytes);

Uint8List identifierToBytes({required IdentifierOpaque identifier}) =>
    RustLib.instance.api.crateApiMainIdentifierToBytes(identifier: identifier);

(DkgRound1SecretOpaque, DkgPublicCommitmentOpaque) dkgPart1(
        {required IdentifierOpaque identifier,
        required int maxSigners,
        required int minSigners}) =>
    RustLib.instance.api.crateApiMainDkgPart1(
        identifier: identifier, maxSigners: maxSigners, minSigners: minSigners);

DkgPublicCommitmentOpaque publicCommitmentFromBytes(
        {required List<int> bytes}) =>
    RustLib.instance.api.crateApiMainPublicCommitmentFromBytes(bytes: bytes);

Uint8List publicCommitmentToBytes(
        {required DkgPublicCommitmentOpaque commitment}) =>
    RustLib.instance.api
        .crateApiMainPublicCommitmentToBytes(commitment: commitment);

(DkgRound2SecretOpaque, List<DkgRound2IdentifierAndShare>) dkgPart2(
        {required DkgRound1SecretOpaque round1Secret,
        required List<DkgCommitmentForIdentifier> round1Commitments}) =>
    RustLib.instance.api.crateApiMainDkgPart2(
        round1Secret: round1Secret, round1Commitments: round1Commitments);

DkgShareToGiveOpaque shareToGiveFromBytes({required List<int> bytes}) =>
    RustLib.instance.api.crateApiMainShareToGiveFromBytes(bytes: bytes);

Uint8List shareToGiveToBytes({required DkgShareToGiveOpaque share}) =>
    RustLib.instance.api.crateApiMainShareToGiveToBytes(share: share);

DkgRound3Data dkgPart3(
        {required DkgRound2SecretOpaque round2Secret,
        required List<DkgCommitmentForIdentifier> round1Commitments,
        required List<DkgRound2IdentifierAndShare> round2Shares}) =>
    RustLib.instance.api.crateApiMainDkgPart3(
        round2Secret: round2Secret,
        round1Commitments: round1Commitments,
        round2Shares: round2Shares);

(SigningNonces, SigningCommitments) signPart1(
        {required List<int> privateShare}) =>
    RustLib.instance.api.crateApiMainSignPart1(privateShare: privateShare);

SigningNonces signingNoncesFromBytes({required List<int> bytes}) =>
    RustLib.instance.api.crateApiMainSigningNoncesFromBytes(bytes: bytes);

Uint8List signingNoncesToBytes({required SigningNonces nonces}) =>
    RustLib.instance.api.crateApiMainSigningNoncesToBytes(nonces: nonces);

SigningCommitments signingCommitmentFromBytes({required List<int> bytes}) =>
    RustLib.instance.api.crateApiMainSigningCommitmentFromBytes(bytes: bytes);

Uint8List signingCommitmentToBytes({required SigningCommitments commitment}) =>
    RustLib.instance.api
        .crateApiMainSigningCommitmentToBytes(commitment: commitment);

SignatureShareOpaque signPart2(
        {required List<IdentifierAndSigningCommitment> noncesCommitments,
        required List<int> message,
        Uint8List? merkleRoot,
        required SigningNonces signingNonces,
        required IdentifierOpaque identifier,
        required List<int> privateShare,
        required List<int> groupPk,
        required int threshold}) =>
    RustLib.instance.api.crateApiMainSignPart2(
        noncesCommitments: noncesCommitments,
        message: message,
        merkleRoot: merkleRoot,
        signingNonces: signingNonces,
        identifier: identifier,
        privateShare: privateShare,
        groupPk: groupPk,
        threshold: threshold);

SignatureShareOpaque signatureShareFromBytes({required List<int> bytes}) =>
    RustLib.instance.api.crateApiMainSignatureShareFromBytes(bytes: bytes);

Uint8List signatureShareToBytes({required SignatureShareOpaque share}) =>
    RustLib.instance.api.crateApiMainSignatureShareToBytes(share: share);

void verifySignatureShare(
        {required List<IdentifierAndSigningCommitment> noncesCommitments,
        required List<int> message,
        Uint8List? merkleRoot,
        required IdentifierOpaque identifier,
        required SignatureShareOpaque share,
        required List<int> publicShare,
        required List<int> groupPk}) =>
    RustLib.instance.api.crateApiMainVerifySignatureShare(
        noncesCommitments: noncesCommitments,
        message: message,
        merkleRoot: merkleRoot,
        identifier: identifier,
        share: share,
        publicShare: publicShare,
        groupPk: groupPk);

Uint8List aggregateSignature(
        {required List<IdentifierAndSigningCommitment> noncesCommitments,
        required List<int> message,
        Uint8List? merkleRoot,
        required List<IdentifierAndSignatureShare> shares,
        required List<int> groupPk,
        required List<IdentifierAndPublicShare> publicShares}) =>
    RustLib.instance.api.crateApiMainAggregateSignature(
        noncesCommitments: noncesCommitments,
        message: message,
        merkleRoot: merkleRoot,
        shares: shares,
        groupPk: groupPk,
        publicShares: publicShares);

Uint8List constructPrivateKey(
        {required List<IdentifierAndPrivateShare> privateShares,
        required List<int> groupPk,
        required int threshold}) =>
    RustLib.instance.api.crateApiMainConstructPrivateKey(
        privateShares: privateShares, groupPk: groupPk, threshold: threshold);

AesGcmCiphertext aesGcmEncrypt(
        {required List<int> key, required List<int> plaintext}) =>
    RustLib.instance.api
        .crateApiMainAesGcmEncrypt(key: key, plaintext: plaintext);

Uint8List aesGcmDecrypt(
        {required List<int> key, required AesGcmCiphertext ciphertext}) =>
    RustLib.instance.api
        .crateApiMainAesGcmDecrypt(key: key, ciphertext: ciphertext);

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<DkgPublicCommitmentOpaque>>
abstract class DkgPublicCommitmentOpaque implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<DkgRound1SecretOpaque>>
abstract class DkgRound1SecretOpaque implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<DkgRound2SecretOpaque>>
abstract class DkgRound2SecretOpaque implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<DkgShareToGiveOpaque>>
abstract class DkgShareToGiveOpaque implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<IdentifierOpaque>>
abstract class IdentifierOpaque implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<SignatureShareOpaque>>
abstract class SignatureShareOpaque implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<frost :: round1 :: SigningCommitments>
abstract class SigningCommitments implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<frost :: round1 :: SigningNonces>
abstract class SigningNonces implements RustOpaqueInterface {}

class AesGcmCiphertext {
  final Uint8List data;
  final Uint8List nonce;

  const AesGcmCiphertext({
    required this.data,
    required this.nonce,
  });

  @override
  int get hashCode => data.hashCode ^ nonce.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AesGcmCiphertext &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          nonce == other.nonce;
}

class DkgCommitmentForIdentifier {
  final IdentifierOpaque identifier;
  final DkgPublicCommitmentOpaque commitment;

  const DkgCommitmentForIdentifier({
    required this.identifier,
    required this.commitment,
  });

  static DkgCommitmentForIdentifier fromRefs(
          {required IdentifierOpaque identifier,
          required DkgPublicCommitmentOpaque commitment}) =>
      RustLib.instance.api.crateApiMainDkgCommitmentForIdentifierFromRefs(
          identifier: identifier, commitment: commitment);

  @override
  int get hashCode => identifier.hashCode ^ commitment.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DkgCommitmentForIdentifier &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          commitment == other.commitment;
}

@freezed
sealed class DkgRound2Error with _$DkgRound2Error implements FrbException {
  const DkgRound2Error._();

  const factory DkgRound2Error.general({
    required String message,
  }) = DkgRound2Error_General;
  const factory DkgRound2Error.invalidProofOfKnowledge({
    required IdentifierOpaque culprit,
  }) = DkgRound2Error_InvalidProofOfKnowledge;
}

class DkgRound2IdentifierAndShare {
  final IdentifierOpaque identifier;
  final DkgShareToGiveOpaque secret;

  const DkgRound2IdentifierAndShare({
    required this.identifier,
    required this.secret,
  });

  static DkgRound2IdentifierAndShare fromRefs(
          {required IdentifierOpaque identifier,
          required DkgShareToGiveOpaque secret}) =>
      RustLib.instance.api.crateApiMainDkgRound2IdentifierAndShareFromRefs(
          identifier: identifier, secret: secret);

  @override
  int get hashCode => identifier.hashCode ^ secret.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DkgRound2IdentifierAndShare &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          secret == other.secret;
}

class DkgRound3Data {
  final IdentifierOpaque identifier;
  final Uint8List privateShare;
  final Uint8List groupPk;
  final List<IdentifierAndPublicShare> publicKeyShares;
  final int threshold;

  const DkgRound3Data({
    required this.identifier,
    required this.privateShare,
    required this.groupPk,
    required this.publicKeyShares,
    required this.threshold,
  });

  @override
  int get hashCode =>
      identifier.hashCode ^
      privateShare.hashCode ^
      groupPk.hashCode ^
      publicKeyShares.hashCode ^
      threshold.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DkgRound3Data &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          privateShare == other.privateShare &&
          groupPk == other.groupPk &&
          publicKeyShares == other.publicKeyShares &&
          threshold == other.threshold;
}

class IdentifierAndPrivateShare {
  final IdentifierOpaque identifier;
  final Uint8List privateShare;

  const IdentifierAndPrivateShare({
    required this.identifier,
    required this.privateShare,
  });

  @override
  int get hashCode => identifier.hashCode ^ privateShare.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentifierAndPrivateShare &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          privateShare == other.privateShare;
}

class IdentifierAndPublicShare {
  final IdentifierOpaque identifier;
  final Uint8List publicShare;

  const IdentifierAndPublicShare({
    required this.identifier,
    required this.publicShare,
  });

  static IdentifierAndPublicShare fromRef(
          {required IdentifierOpaque identifier,
          required List<int> publicShare}) =>
      RustLib.instance.api.crateApiMainIdentifierAndPublicShareFromRef(
          identifier: identifier, publicShare: publicShare);

  @override
  int get hashCode => identifier.hashCode ^ publicShare.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentifierAndPublicShare &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          publicShare == other.publicShare;
}

class IdentifierAndSignatureShare {
  final IdentifierOpaque identifier;
  final SignatureShareOpaque share;

  const IdentifierAndSignatureShare({
    required this.identifier,
    required this.share,
  });

  static IdentifierAndSignatureShare fromRefs(
          {required IdentifierOpaque identifier,
          required SignatureShareOpaque share}) =>
      RustLib.instance.api.crateApiMainIdentifierAndSignatureShareFromRefs(
          identifier: identifier, share: share);

  @override
  int get hashCode => identifier.hashCode ^ share.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentifierAndSignatureShare &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          share == other.share;
}

class IdentifierAndSigningCommitment {
  final IdentifierOpaque identifier;
  final SigningCommitments commitment;

  const IdentifierAndSigningCommitment({
    required this.identifier,
    required this.commitment,
  });

  static IdentifierAndSigningCommitment fromRefs(
          {required IdentifierOpaque identifier,
          required SigningCommitments commitment}) =>
      RustLib.instance.api.crateApiMainIdentifierAndSigningCommitmentFromRefs(
          identifier: identifier, commitment: commitment);

  @override
  int get hashCode => identifier.hashCode ^ commitment.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentifierAndSigningCommitment &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          commitment == other.commitment;
}

@freezed
sealed class SignAggregationError
    with _$SignAggregationError
    implements FrbException {
  const SignAggregationError._();

  const factory SignAggregationError.general({
    required String message,
  }) = SignAggregationError_General;
  const factory SignAggregationError.invalidSignShare({
    required IdentifierOpaque culprit,
  }) = SignAggregationError_InvalidSignShare;
}
