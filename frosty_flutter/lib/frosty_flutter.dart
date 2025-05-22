library;
import 'package:flutter/widgets.dart';
import 'package:frosty/frosty.dart';
export 'package:frosty/frosty.dart';

/// A widget that ensures the frosty library is loaded before use.
class FrostyLoader extends StatefulWidget {

  /// The widget to show whilst frosty is loading
  final Widget loadChild;
  /// The builder for a library load error
  final Widget Function(BuildContext context, Object? error) errorBuilder;
  /// The builder called once the library has loaded
  final WidgetBuilder builder;

  /// Whilst the library is loading, the [loadChild] widget will be displayed.
  /// If there is an error, the [errorBuilder] will be called with the error to
  /// obtain a widget to display. If the library loads successfully, [builder]
  /// will be called instead.
  const FrostyLoader({
    super.key,
    required this.loadChild,
    required this.errorBuilder,
    required this.builder,
  });

  @override
  State<FrostyLoader> createState() => _FrostyLoaderState();

}

class _FrostyLoaderState extends State<FrostyLoader> {

  late Future<void> loadResult;

  @override
  void initState() {
    super.initState();
    loadResult = loadFrosty();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    builder: (context, snapshot) {

      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return widget.errorBuilder(context, snapshot.error);
        }
        return widget.builder(context);
      }

      return widget.loadChild;

    },
    future: loadResult,
  );

}
