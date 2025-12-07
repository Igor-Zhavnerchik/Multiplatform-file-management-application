import 'package:cross_platform_project/data/data_source/auth_data_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDataStorageProvider = Provider<AuthDataStorage>((ref) {
  return AuthDataStorage();
});
