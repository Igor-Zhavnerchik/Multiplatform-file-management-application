import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';
import 'package:cross_platform_project/presentation/screens/home_screen/utility_widgets/adaptive_gesture_detectore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FileViewMode { grid, list }

class FileView extends ConsumerWidget {
  final FileViewMode mode;
  const FileView({this.mode = FileViewMode.list, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final currentFolder = homeState.currentFolder;

    if (currentFolder == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final childrenStream = ref.watch(childrenListProvider(currentFolder.id));

    return childrenStream.when(
      data: (children) => AdaptiveGestureDetector(
        behavior: HitTestBehavior.opaque,
        onSecondaryTapDownDesktop: (details) {
          ref
              .read(dialogViewModelProvider.notifier)
              .showCustomDialog(
                content: FolderOperationSelectMenu(folder: currentFolder),
                position: details.globalPosition,
              );
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: mode == FileViewMode.list
              ? const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 56,
                )
              : const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 140,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
          itemCount: children.length,
          itemBuilder: (context, index) {
            final file = children[index];
            return FileViewElement(element: file, mode: mode);
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}

class FileViewElement extends ConsumerWidget {
  final FileViewMode mode;
  final FileEntity element;
  const FileViewElement({required this.element, required this.mode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSelected = ref.watch(homeViewModelProvider).selected == element;

    return AdaptiveGestureDetector(
      onSecondaryTapDownDesktop: (details) {
        ref
            .read(dialogViewModelProvider.notifier)
            .showCustomDialog(
              content: FileOperationSelectMenu(entity: element),
              position: details.globalPosition,
            );
      },
      onTapDesktop: () =>
          ref.read(homeViewModelProvider.notifier).setSelected(element),
      onDoubleTapDesktop: () =>
          ref.read(homeViewModelProvider.notifier).openElement(element),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {}, // Для эффекта нажатия
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: mode == FileViewMode.grid
              ? _buildGridItem(theme)
              : _buildListItem(theme),
        ),
      ),
    );
  }

  Widget _buildGridItem(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          element.isFolder
              ? Icons.folder_rounded
              : Icons.insert_drive_file_rounded,
          size: 48,
          color: element.isFolder
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
        ),
        const SizedBox(height: 8),
        Text(
          element.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildListItem(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            element.isFolder
                ? Icons.folder_rounded
                : Icons.insert_drive_file_rounded,
            color: element.isFolder
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              element.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
