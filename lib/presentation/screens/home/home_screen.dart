import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    debugLog('building home');
    final homeNotifier = ref.read(homeViewModelProvider.notifier);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileHomeScreen();
        } else {
          return DesktopHomeScreen();
        }
      },
    );
  }
}

class MobileHomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: NavigationPanel(), body: FileView());
  }
}

class DesktopHomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: NavigationPanel(),
      body: Row(
        children: [
          FolderView(),
          VerticalDivider(color: theme.colorScheme.secondary),
          Expanded(child: FileView()),
        ],
      ),
    );
  }
}

enum FileViewMode { grid, list }

class FileView extends ConsumerWidget {
  final FileViewMode mode;
  FileView({this.mode = FileViewMode.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final currentFolder = homeState.currentFolder;
    if (currentFolder == null) {
      return Text('Loading...');
    }
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
        },
        child: GridView(
          gridDelegate: mode == FileViewMode.list
              ? SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 60,
                )
              : SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                ),
          children: [
            for (var file in children)
              if (file.isFolder) FileViewElement(element: file, mode: mode),
            for (var file in children)
              if (!file.isFolder) FileViewElement(element: file, mode: mode),
          ],
        ),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text("Error: $error, $stackTrace"),
    );
  }
}

class FileViewElement extends ConsumerWidget {
  final FileViewMode mode;
  final FileEntity element;
  FileViewElement({required this.element, required this.mode});

  IconData getIcon() {
    return element.isFolder ? Icons.folder : Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final iconSize = constraints.maxHeight - 20;
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

            child: switch (mode) {
              FileViewMode.grid => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(getIcon(), size: iconSize),
                  Text(element.name),
                ],
              ),
              FileViewMode.list => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(getIcon(), size: iconSize),
                  Text(element.name),
                ],
              ),
            },
          ),
        );
      },
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
    final folderStream = ref.watch(onlyFoldersListProvider(null));
    return folderStream.when(
      data: (data) => SizedBox(
        width: 200,
        child: ListView(children: [FolderWidget(folder: data.first)]),
      ),
      error: (error, stackTrace) => Text('Error: $error, $stackTrace'),
      loading: () => CircularProgressIndicator(),
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
    final folderStream = ref.watch(
      onlyFoldersListProvider(
        widget.folder.id.isEmpty ? null : widget.folder.id,
      ),
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(homeViewModelProvider.notifier)
                        .openElement(widget.folder);
                  },

                  child: Text(
                    widget.folder.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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

class NavigationControls extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final notifier = ref.read(homeViewModelProvider.notifier);
    return Row(
      children: [
        IconButton(
          onPressed: state.canGoBack ? () => notifier.goBack() : null,
          icon: Icon(Icons.arrow_back),
          disabledColor: Colors.grey,
        ),
        IconButton(
          onPressed: state.canGoForward ? () => notifier.goForward() : null,
          icon: Icon(Icons.arrow_forward),
          disabledColor: Colors.grey,
        ),
      ],
    );
  }
}

class NavigationPanel extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AppBar(
      leading: NavigationControls(),
      leadingWidth: 96,
      backgroundColor: theme.colorScheme.secondary,

      actions: [
        FilledButton(
          onPressed: () =>
              ref.read(fileOperationsViewModelProvider.notifier).startScan(),
          child: Text('Scan FS'),
        ),

        FilledButton(
          onPressed: () =>
              ref.read(fileOperationsViewModelProvider.notifier).startSync(),
          child: Text('Syncronize'),
        ),

        FilledButton(
          onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
          child: Text('Sign Out'),
        ),
      ],
    );
  }
}
