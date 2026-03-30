import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'core/network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force full stack traces in debug/profile logs for framework and async errors.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrintStack(
      label: details.exceptionAsString(),
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Unhandled async error: $error');
    debugPrintStack(stackTrace: stack);
    return false;
  };

  final dir = await getApplicationDocumentsDirectory();

  runApp(
    ProviderScope(
      overrides: [
        cacheDirProvider.overrideWithValue(dir.path),
      ],
      child: const App(),
    ),
  );
}
