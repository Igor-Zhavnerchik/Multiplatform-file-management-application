import 'package:cross_platform_project/data/services/file_picker_service.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filePickerServiceProvider = Provider.autoDispose<FilePickerService>((
  ref,
) {
  final pathService = ref.watch(storagePathServiceProvider);
  return FilePickerService(pathService: pathService);
});
