import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../features/settings/providers/settings_provider.dart';
import 'router/router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router    = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'ResumePilot',
      debugShowCheckedModeBanner: false,
      // Light / dark themes from design system
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Driven by user settings — falls back to system until settings load
      themeMode: themeMode,
      // GoRouter drives all navigation
      routerConfig: router,
    );
  }
}
// }
