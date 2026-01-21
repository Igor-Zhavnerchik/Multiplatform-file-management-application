import 'package:cross_platform_project/common/utility/result.dart';

abstract class SyncRepository {
  Future<Result<void>> syncronizeAll();
}
