import 'package:cross_platform_project/data/services/uuid_generation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uuidGenerationServiceProvider =
    Provider.autoDispose<UuidGenerationService>((ref) {
      return UuidGenerationService();
    });
