import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';

abstract class SyncRepository {
  Future<Result<void>> syncronizeAll();
  void addSyncEvent({required SyncEvent event});
}
