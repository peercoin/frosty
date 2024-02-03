import 'dart:ffi';
import 'package:path/path.dart';
import 'dart:io';
import 'rust_ffi.g.dart';
export 'rust_ffi.g.dart';

late FrostyRust rustApi;

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

Future<void> loadFrostyImpl() async {
  rustApi = FrostyRustImpl(DynamicLibrary.open(_libraryPath()));
}
