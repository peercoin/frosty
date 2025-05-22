import 'package:flutter/material.dart';
import 'package:frosty_flutter/frosty_flutter.dart' as frosty;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text("Frosty Example")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _getWidget(context)
        )
      )
    )
  );

  Widget _getWidget(BuildContext context) => frosty.FrostyLoader(
    loadChild: const Text("Loading frosty..."),
    errorBuilder: (context, error) => Text("Error $error"),
    builder: (context) => Text("Identifier for 1 = ${frosty.Identifier.fromUint16(1)}"),
  );

}
