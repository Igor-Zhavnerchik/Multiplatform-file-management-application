import 'package:cross_platform_project/data/services/hash_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hashServiceProvider = Provider.autoDispose<HashService>(
  (ref) => HashService(),
);
