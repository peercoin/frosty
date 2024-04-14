import 'package:coinlib/coinlib.dart';
import 'group.dart';
import 'private.dart';

/// Contains details required specifically for providing a signature share. This
/// contains the [GroupKeyInfo] and [PrivateKeyInfo] but excludes the
/// public shares which aren't needed.
class SigningKeyInfo with Writable {

  final GroupKeyInfo group;
  final PrivateKeyInfo private;

  SigningKeyInfo({
    required this.group,
    required this.private,
  });

  SigningKeyInfo.fromReader(BytesReader reader) : this(
    group: GroupKeyInfo.fromReader(reader),
    private: PrivateKeyInfo.fromReader(reader),
  );

  @override
  void write(Writer writer) {
    group.write(writer);
    private.write(writer);
  }

}
