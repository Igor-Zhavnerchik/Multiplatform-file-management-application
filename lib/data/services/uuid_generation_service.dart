import 'package:uuid/uuid.dart';

class UuidGenerationService {
  String generateId({String? userRoot}) {
    return userRoot != null
        ? Uuid().v5(Namespace.nil.value, userRoot)
        : Uuid().v7();
  }
}
