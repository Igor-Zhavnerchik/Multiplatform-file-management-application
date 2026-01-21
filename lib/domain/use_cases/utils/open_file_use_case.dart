import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/services/file_open_service.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class OpenFileUseCase {
  final FileOpenService opener;

  OpenFileUseCase({required this.opener});

  Future<Result<void>> call({required FileEntity file}) async {
    return await opener.openFile(file.id);
  }
}
