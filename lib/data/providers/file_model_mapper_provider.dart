import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileModelMapperProvider = Provider.autoDispose<FileModelMapper>((ref) {
  return FileModelMapper();
});
