import 'package:cross_platform_project/core/providers/settings_service_provider.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileModelMapperProvider = Provider<FileModelMapper>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return FileModelMapper(settings: settings);
});
