import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:open_filex/open_filex.dart';

class FileOpenService {
  final StoragePathService pathService;

  FileOpenService({required this.pathService});

  Future<Result<void>> openFile(String fileId) async {
    final filePath = await pathService.getLocalPath(fileId: fileId);
    final openResult = await OpenFilex.open(filePath);
    return openResult.type == ResultType.done
        ? Success(null)
        : Failure('Failed to open file: ${openResult.message}');
  }
}
