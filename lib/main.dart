import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/app_coordinator_provider.dart';
import 'package:cross_platform_project/core/providers/router_provider.dart';
import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:cross_platform_project/data/data_source/local/database/database_providers.dart';
import 'package:cross_platform_project/core/utility/storage_path_service.dart';
import 'package:cross_platform_project/data/providers/file_system_scan_providers.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    debugLog('Flutter error: ${details.exceptionAsString()} ');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugLog('Platform error: $error stack: $stack');
    return true;
  };

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://iasonhubsoxjnhjxatrb.supabase.co',
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlhc29uaHVic294am5oanhhdHJiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDYwNzM3MiwiZXhwIjoyMDc2MTgzMzcyfQ.6JiI1YaIhgQG_3a4236dK_Nh2vQsFQg2A0c7YkV4P6w",
  );

  final appDirPath = (await getApplicationDocumentsDirectory()).path;
  final database = AppDatabase();
  final filesDao = FilesDao(database);
  final pathService = StoragePathService(appDirPath, filesDao);

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        filesTableProvider.overrideWithValue(filesDao),
        storagePathServiceProvider.overrideWithValue(pathService),
      ],
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appCoordinatorProvider);

    final router = ref.watch(routerProvider);
    ref.watch(fileSystemWatcherProvider).watchFS();

    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}




//access key
// id: 1a9bff167f53af73c2a4a842d5ef1ae5
// secret: 8c7fa730f62e2b80f4b87bc0565c1b247b8730ace44457571b1f72b333bde901