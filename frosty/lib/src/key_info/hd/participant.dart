import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/src/key_info/participant.dart';
import 'aggregate.dart';
import 'derivable.dart';
import 'hd_key_info.dart';
import 'signing.dart';

class HDParticipantKeyInfo extends ParticipantKeyInfo implements HDDerivableInfo {

  @override
  final HDKeyInfo hdInfo;

  HDParticipantKeyInfo({
    required super.group,
    required super.publicShares,
    required super.private,
    required this.hdInfo,
  });

  HDParticipantKeyInfo.master({
    required super.group,
    required super.publicShares,
    required super.private,
  }) : hdInfo = HDKeyInfo.master;

  HDParticipantKeyInfo.masterFromInfo(ParticipantKeyInfo info)
    : this.master(
      group: info.group,
      publicShares: info.publicShares,
      private: info.private,
    );

  HDParticipantKeyInfo.fromReader(super.reader)
    : hdInfo = HDKeyInfo.fromReader(reader), super.fromReader();

  /// Convenience constructor to construct from serialised [bytes].
  HDParticipantKeyInfo.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  HDParticipantKeyInfo.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    hdInfo.write(writer);
    super.write(writer);
  }

  /// Get the singing information alongside the [HDKeyInfo].
  HDSigningKeyInfo get hdSigning => HDSigningKeyInfo(
    group: group,
    private: private,
    hdInfo: hdInfo,
  );

  /// Get the aggregation information alongside the [HDKeyInfo].
  HDAggregateKeyInfo get hdAggregate => HDAggregateKeyInfo(
    group: group,
    publicShares: publicShares,
    hdInfo: hdInfo,
  );

  @override
  HDParticipantKeyInfo derive(int index) {
    final (tweak, newHdInfo) = hdInfo.deriveTweakAndInfo(groupKey, index);
    return HDParticipantKeyInfo(
      group: group.tweak(tweak)!,
      publicShares: publicShares.tweak(tweak)!,
      private: private.tweak(tweak)!,
      hdInfo: newHdInfo,
    );
  }

}
