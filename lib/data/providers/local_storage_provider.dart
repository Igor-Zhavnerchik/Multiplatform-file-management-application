import 'package:cross_platform_project/data/data_source/local/local_storage_service.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageProvider = Provider.autoDispose<LocalStorageService>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  return LocalStorageService(pathService: pathService);
});
