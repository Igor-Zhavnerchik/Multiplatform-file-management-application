import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homescreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var homeNotifier = ref.read(homeViewModelProvider.notifier);

    ref.listen(homeViewModelProvider, (prev, next) {
      if (next.openDialog) {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (dialogContext) => ContextDialog(
            dialog: next.dialog!,
            position: next.dialogPosition,
            dialogContext: dialogContext,
          ),
        ).then((nextDialog) {
          nextDialog != null
              ? homeNotifier.setDialog(nextDialog)
              : homeNotifier.clearDialog();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,

        actions: [
          ElevatedButton(
            onPressed: () =>
                ref.read(fileOperationsViewModelProvider.notifier).startScan(),
            child: Text('Scan FS'),
          ),

          ElevatedButton(
            onPressed: () =>
                ref.read(fileOperationsViewModelProvider.notifier).startSync(),
            child: Text('Syncronize'),
          ),

          ElevatedButton(
            onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
            child: Text('Sign Out'),
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
    final homeState = ref.watch(homeViewModelProvider);
    final currentFolder = homeState.currentFolder;
    if (currentFolder == null) return Text('No Folder Selected');
    final childrenStream = ref.watch(childrenListProvider(currentFolder.id));
    return childrenStream.when(
      data: (children) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onSecondaryTapDown: (details) {
          ref
              .read(homeViewModelProvider.notifier)
              .setDialog(
                ContextDialogType.inFolderMenu,
                dialogPosition: details.globalPosition,
              );
          for (var file in children) {
            print(file.name);
          }
          print('');
        },
        child: GridView(
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapDown: (details) {
        ref.read(homeViewModelProvider.notifier)
          ..setSelected(element)
          ..setDialog(
            ContextDialogType.optionMenu,
            dialogPosition: details.globalPosition,
          );
      },

      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () =>
            ref.read(homeViewModelProvider.notifier).setSelected(element),
        onDoubleTap: () =>
            ref.read(homeViewModelProvider.notifier).openElement(element),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(getIcon()), Text(element.name)],
        ),
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
    final folderStream = ref.watch(onlyFoldersListProvider(widget.folder.id));

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
              GestureDetector(
                onTap: () {
                  ref
                      .read(homeViewModelProvider.notifier)
                      .openElement(widget.folder);
                },

                child: Text(widget.folder.name),
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
  }
}
