import 'package:cross_platform_project/presentation/widgets/file_operations_view/file_operations_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileOperationsViewModelProvider =
    NotifierProvider<FileOperationsViewModel, FileOperationsState>(() {
      return FileOperationsViewModel();
    });
