import 'package:cross_platform_project/data/services/file_open_service.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileOpenServiceProvider = Provider<FileOpenService>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  return FileOpenService(pathService: pathService);
});
