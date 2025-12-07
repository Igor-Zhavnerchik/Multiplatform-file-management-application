import 'dart:typed_data';

import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model.dart';

abstract class SyncActionSource {
  Future<Result<void>> updateFile({required FileModel model});
  Future<Result<Uint8List>> readFile({required FileModel model});
  Future<Result<void>> writeFile({required FileModel model, Uint8List? data});
  Future<Result<void>> deleteFile({
    required FileModel model,
    bool softDelete = true,
  });
}
