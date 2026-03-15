import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'core/network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
