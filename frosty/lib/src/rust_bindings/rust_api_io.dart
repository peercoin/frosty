import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'generated/frb_generated.dart';

const _name = "frosty_rust";

String _libraryPath() {
  // Only linux is available currently

  final String localLib, flutterLib;

  if (Platform.isLinux || Platform.isAndroid) {
    flutterLib = localLib = "lib$_name.so";
  } else if (Platform.isMacOS || Platform.isIOS) {
    // Dylib if built in build directory, or framework if using flutter
    localLib = "lib$_name.dylib";
    flutterLib = "$_name.framework/$_name";
  } else if (Platform.isWindows) {
    flutterLib = localLib = "$_name.dll";
  } else {
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }

  // Exists in build/?
  final targetPath = join(Directory.current.path, "build", localLib);
  if (File(targetPath).existsSync()) return targetPath;

  // Try to load from flutter library name
  return flutterLib;

}

Future<void> loadFrostyImpl() => RustLib.init(
  externalLibrary: ExternalLibrary.open(_libraryPath()),
);
