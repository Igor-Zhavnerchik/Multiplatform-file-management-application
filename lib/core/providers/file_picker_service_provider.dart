import 'package:cross_platform_project/core/services/file_picker_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filePickerServiceProvider = Provider<FilePickerService>(
  (ref) => FilePickerService(),
);
