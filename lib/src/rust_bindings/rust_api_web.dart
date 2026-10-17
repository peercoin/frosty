import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show ExternalLibraryLoaderConfig, loadExternalLibrary;

import 'generated/frb_generated.dart';

Future<void> loadFrostyImpl({String? webRoot}) async {
  webRoot ??= 'assets/packages/frosty/web/pkg/frosty_rust';

  final externalLibrary = await loadExternalLibrary(
    ExternalLibraryLoaderConfig(
      stem: webRoot,
      ioDirectory: null,
      webPrefix: '',
    ),
  );
  await RustLib.init(externalLibrary: externalLibrary);
}
