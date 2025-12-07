import 'dart:io';

import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';
import 'package:cross_platform_project/presentation/widgets/file_operations_view/file_operations_view.dart';
import 'package:cross_platform_project/presentation/widgets/file_operations_view/file_operations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homescreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,

        actions: [
          ElevatedButton(
            onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
            child: Text('Sign Out'),
          ),
          ElevatedButton(
            onPressed: () {
              var selected = ref.read(homeViewModelProvider).selected!;
              showModalBottomSheet(
                context: context,
                builder: (_) => ProviderScope(
                  child: FileOperationsView(
                    fileOperationArgs: FileOperationDTO(
                      fileOperation: FileOperation.create,
                      selectedFile: selected,
                    ),
                  ),
                ),
              );
            },
            child: Text('Create'),
          ),
          ElevatedButton(
            onPressed: () {
              var selected = ref.read(homeViewModelProvider).selected!;
              showModalBottomSheet(
                context: context,
                builder: (_) => ProviderScope(
                  child: FileOperationsView(
                    fileOperationArgs: FileOperationDTO(
                      fileOperation: FileOperation.delete,
                      selectedFile: selected,
                    ),
                  ),
                ),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
      body: Row(
        children: [
          FolderView(),
          Expanded(child: FileView()),
        ],
      ),
    );
  }
}

class FileView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.read(homeViewModelProvider);
    final currentFolder = homeState.currentFolder;
    if (currentFolder == null) return Text('No Folder Selected');
    final childrenStream = ref.watch(childrenListProvider(currentFolder.id));
    return childrenStream.when(
      data: (children) => GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
        ),
        children: [
          for (var file in children)
            if (file.isFolder) FileViewElement(element: file),
          for (var file in children)
            if (!file.isFolder) FileViewElement(element: file),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text("Error: $error"),
    );
  }
}

class FileViewElement extends ConsumerWidget {
  final FileEntity element;
  FileViewElement({required this.element});

  IconData getIcon() {
    return element.isFolder ? Icons.folder : Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      hoverColor: Colors.grey.withValues(alpha: 0.1),
      onTap: () =>
          ref.read(homeViewModelProvider.notifier).setSelected(element),
      onDoubleTap: () =>
          ref.read(homeViewModelProvider.notifier).openElement(element),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Icon(getIcon()), Text(element.name)],
      ),
    );
  }
}

class FolderView extends ConsumerStatefulWidget {
  @override
  ConsumerState<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends ConsumerState<FolderView> {
  @override
  Widget build(BuildContext context) {
    final rootStream = ref.watch(childrenListProvider(null));

    return rootStream.when(
      data: (root) => FolderWidget(folder: root[0]),
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}

class FolderWidget extends ConsumerStatefulWidget {
  FolderWidget({super.key, required this.folder});

  final FileEntity folder;

  @override
  ConsumerState<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends ConsumerState<FolderWidget> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    if (widget.folder != null) {
      final folderStream = ref.watch(
        onlyFoldersListProvider(widget.folder!.id),
      );

      return folderStream.when(
        data: (folders) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    isOpen = !isOpen;
                  }),
                  icon: Icon(
                    isOpen
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                  ),
                ),
                Icon(Icons.folder),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(homeViewModelProvider.notifier)
                        .setCurrentFolder(widget.folder!);
                    ref
                        .read(homeViewModelProvider.notifier)
                        .setSelected(widget.folder!);
                  },
                  child: Text(widget.folder!.name),
                ),
              ],
            ),
            Offstage(
              offstage: !isOpen,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var folder in folders) FolderWidget(folder: folder),
                  ],
                ),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => CircularProgressIndicator(),
      );
    } else {
      return Column();
    }
  }
}
