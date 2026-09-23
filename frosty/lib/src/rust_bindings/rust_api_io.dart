import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:path/path.dart';

import 'dart:io';

import 'generated/frb_generated.dart';

const _name = "frosty_rust";

// Returns null if the path is to be handled by FRB instead
String? _libraryPath() {
  final String? localLib, flutterLib;

  if (Platform.isLinux || Platform.isAndroid) {
    flutterLib = localLib = "lib$_name.so";
  } else if (Platform.isMacOS || Platform.isIOS) {
    // Dylib if built in build directory, or null to use default loader if using
    // flutter
    localLib = "lib$_name.dylib";
    flutterLib = null;
  } else if (Platform.isWindows) {
    flutterLib = localLib = "$_name.dll";
  } else {
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }

  // Dart build hooks place bundled native assets in .dart_tool/lib. Prefer
  // that output over the legacy manually-built library in build/.
  final localPaths = [
    join(Directory.current.path, ".dart_tool", "lib", localLib),
    join(Directory.current.path, "build", localLib),
  ];
  for (final path in localPaths) {
    if (File(path).existsSync()) return path;
  }

  // Try to load from flutter library name
  return flutterLib;
}

Future<void> loadFrostyImpl({String? webRoot}) {
  final libPath = _libraryPath();
  return RustLib.init(
    externalLibrary: libPath == null ? null : ExternalLibrary.open(libPath),
  );
}
