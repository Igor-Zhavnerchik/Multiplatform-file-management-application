import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FileView extends ConsumerWidget {
  const FileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final currentFolder = homeState.currentFolder;
    final isMobile = MediaQuery.of(context).size.width <= 500;

    if (currentFolder == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final childrenStream = ref.watch(childrenListProvider(currentFolder.id));

    return childrenStream.when(
      data: (children) => Column(
        children: [
          if (children.isNotEmpty && !isMobile) const _FileTableHeader(),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  ref.read(homeViewModelProvider.notifier).setSelected(null),
              onSecondaryTapDown: (details) {
                _showMenu(
                  ref,
                  context,
                  FolderOperationSelectMenu(folder: currentFolder),
                  details.globalPosition,
                  isFile: false,
                );
              },
              child: children.isEmpty
                  ? const Center(child: Text('Folder is empty'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        return FileViewElement(
                          element: children[index],
                          parentFolder: currentFolder,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}

void _showMenu(
  WidgetRef ref,
  BuildContext context,
  Widget content,
  Offset position, {
  required bool isFile,
}) {
  final screenSize = MediaQuery.of(context).size;
  const double menuWidth = 220;
  final double menuHeight = isFile ? 280 : 180;

  double finalX = position.dx;
  double finalY = position.dy;

  if (finalX + menuWidth > screenSize.width - 10) {
    finalX = screenSize.width - menuWidth - 10;
  }
  if (finalY + menuHeight > screenSize.height - 20) {
    finalY = position.dy - menuHeight;
  }
  if (finalY < 10) finalY = 10;

  ref
      .read(dialogViewModelProvider.notifier)
      .showCustomDialog(content: content, position: Offset(finalX, finalY));
}

class FileViewElement extends ConsumerWidget {
  final FileEntity element;
  final FileEntity parentFolder;

  const FileViewElement({
    required this.element,
    required this.parentFolder,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final homeState = ref.watch(homeViewModelProvider);
    final homeNotifier = ref.read(homeViewModelProvider.notifier);
    final isMobile = MediaQuery.of(context).size.width <= 500;
    final isSelected = homeState.selected?.id == element.id;

    return Listener(
      onPointerDown: (event) {
        if (!isMobile && event.buttons == 1) {
          homeNotifier.setSelected(element);
        }
      },
      child: GestureDetector(
        onTap: isMobile ? () => homeNotifier.openElement(element) : null,
        onDoubleTap: !isMobile ? () => homeNotifier.openElement(element) : null,
        onSecondaryTapDown: (details) {
          _showMenu(
            ref,
            context,
            isSelected
                ? FileOperationSelectMenu(entity: element)
                : FolderOperationSelectMenu(folder: parentFolder),
            details.globalPosition,
            isFile: isSelected,
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth > 500
                  ? _buildDesktopListItem(theme)
                  : _buildMobileListItem(theme, ref);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopListItem(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _SyncStatusOverlay(
            status: _getStatusInfo(theme),
            child: Icon(
              element.isFolder
                  ? Icons.folder_rounded
                  : Icons.insert_drive_file_rounded,
              size: 24,
              color: element.isFolder
                  ? theme.colorScheme.primary
                  : _getIconColor(theme),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              element.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              element.isFolder ? '--' : _formatSize(element.size),
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 140,
            child: Text(
              _formatDate(element.updatedAt),
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileListItem(ThemeData theme, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _SyncStatusOverlay(
            status: _getStatusInfo(theme),
            child: Icon(
              element.isFolder
                  ? Icons.folder_rounded
                  : Icons.insert_drive_file_rounded,
              size: 36,
              color: element.isFolder
                  ? theme.colorScheme.primary
                  : _getIconColor(theme),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  element.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatDate(element.updatedAt),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              ref.read(homeViewModelProvider.notifier).setSelected(element);
              _showMenu(
                ref,
                ScaffoldMessenger.of(ref.context).context,
                FileOperationSelectMenu(entity: element),
                Offset.zero,
                isFile: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getIconColor(ThemeData theme) => theme.colorScheme.onSurfaceVariant;

  _StatusInfo? _getStatusInfo(ThemeData theme) {
    switch (element.syncStatus) {
      case SyncStatus.downloading:
      case SyncStatus.uploading:
        return _StatusInfo(
          icon: Icons.sync_rounded,
          color: theme.colorScheme.primary,
        );
      case SyncStatus.failedDownload:
      case SyncStatus.failedUpload:
        return _StatusInfo(
          icon: Icons.error_outline_rounded,
          color: theme.colorScheme.error,
        );
      case SyncStatus.syncronized:
        return element.downloadEnabled
            ? _StatusInfo(
                icon: Icons.cloud_done_outlined,
                color: theme.colorScheme.primary,
              )
            : null;
      default:
        return null;
    }
  }

  String _formatSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    int unitIndex = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  String _formatDate(DateTime dateTime) =>
      DateFormat('dd.MM.yyyy HH:mm').format(dateTime.toLocal());
}

class _SyncStatusOverlay extends StatelessWidget {
  final Widget child;
  final _StatusInfo? status;

  const _SyncStatusOverlay({required this.child, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(status!.icon, color: status!.color),
          ),
        ),
      ],
    );
  }
}

class _StatusInfo {
  final IconData icon;
  final Color color;
  const _StatusInfo({required this.icon, required this.color});
}

class _FileTableHeader extends StatelessWidget {
  const _FileTableHeader();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.bold,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('NAME', style: style)),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            child: Text('SIZE', style: style, textAlign: TextAlign.right),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 140,
            child: Text('MODIFIED', style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
