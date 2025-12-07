import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/widgets/file_operations_view/file_operations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';

class FileOperationsView extends ConsumerWidget {
  final FileOperationDTO fileOperationArgs;

  FileOperationsView({super.key, required this.fileOperationArgs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (fileOperationArgs.fileOperation) {
      FileOperation.delete => DeleteForm(
        toDelete: fileOperationArgs.selectedFile,
      ),
      FileOperation.create => CreateForm(
        parent: fileOperationArgs.selectedFile,
      ), //CreateForm(),
    };
  }
}

class DeleteForm extends ConsumerWidget {
  final FileEntity toDelete;

  DeleteForm({super.key, required this.toDelete});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text('Are you sure?'),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => ref
                  .read(fileOperationsViewModelProvider.notifier)
                  .deleteFile(toDelete: toDelete),
              child: Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
          ],
        ),
      ],
    );
  }
}

class CreateForm extends ConsumerWidget {
  final FileEntity parent;

  CreateForm({super.key, required this.parent});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isFolder = false;
    ref
        .watch(fileOperationsViewModelProvider)
        .whenData((state) => isFolder = state.newFileIsFolder);

    return Column(
      children: [
        Row(
          children: [
            Text('Create Folder: '),
            Checkbox(
              value: isFolder,
              onChanged: (value) => ref
                  .read(fileOperationsViewModelProvider.notifier)
                  .setNewFileState(isFolder: value),
            ),
          ],
        ),
        TextField(
          decoration: InputDecoration(labelText: 'File Name: '),
          onChanged: (value) => ref
              .read(fileOperationsViewModelProvider.notifier)
              .setNewFileState(name: value),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => ref
                  .read(fileOperationsViewModelProvider.notifier)
                  .getNewFilePath(),
              child: Text('pick file'),
            ),
            Text('path'),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => ref
                  .read(fileOperationsViewModelProvider.notifier)
                  .createFile(parent: parent),
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}
