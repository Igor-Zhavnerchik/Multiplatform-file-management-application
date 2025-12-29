import 'package:uuid/uuid.dart';

class UuidGenerationService {
  String generateId({bool isRoot = false}){
    return isRoot? Uuid().v5(Namespace.nil.value, '') : Uuid().v7();
  }
}