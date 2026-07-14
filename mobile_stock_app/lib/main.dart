import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'core/di/core_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/brand/presentation/screens/brand_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-warm the SQLite database BEFORE runApp so that `databaseProvider`
  // can be safely read synchronously (`.requireValue`) by every feature's
  // repository provider. This avoids sprinkling FutureBuilder/AsyncValue
  // handling throughout the whole app for something that only needs to
  // happen once, at startup.
  final db = await AppDatabase.instance.database;

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWith((ref) => Future.value(db)),
      ],
      child: const StockManagerApp(),
    ),
  );
}

class StockManagerApp extends ConsumerWidget {
  const StockManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'StockPro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      // TEMPORARY entry point: once the Dashboard + bottom-nav shell feature
      // is built, this will be replaced by a RootShell widget that hosts
      // Dashboard / Products / Brands / Reports / Settings as tabs.
      home: const BrandListScreen(),
    );
  }
}
