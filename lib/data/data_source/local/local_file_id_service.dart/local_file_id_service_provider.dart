import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localFileIdServiceProvider = Provider.autoDispose<LocalFileIdService>(
  (ref) => LocalFileIdService(),
);
