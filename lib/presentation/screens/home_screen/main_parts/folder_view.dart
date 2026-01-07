import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FolderView extends ConsumerWidget {
  const FolderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderStream = ref.watch(onlyFoldersListProvider(null));
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
      ),
      child: folderStream.when(
        data: (data) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            if (data.isNotEmpty)
              FolderWidget(folder: data.first)
            else
              const Center(child: Text('No folders')),
          ],
        ),
        error: (error, _) => Center(
          child: Icon(Icons.error_outline, color: theme.colorScheme.error),
        ),
        loading: () => const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

class FolderWidget extends ConsumerStatefulWidget {
  const FolderWidget({super.key, required this.folder, this.depth = 0});

  final FileEntity folder;
  final int depth;

  @override
  ConsumerState<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends ConsumerState<FolderWidget> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeState = ref.watch(homeViewModelProvider);
    final isCurrent = homeState.currentFolder?.id == widget.folder.id;

    final folderStream = ref.watch(
      onlyFoldersListProvider(
        widget.folder.id.isEmpty ? null : widget.folder.id,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Основная строка папки
        InkWell(
          onTap: () {
            ref.read(homeViewModelProvider.notifier).openElement(widget.folder);
            setState(() => isOpen = !isOpen);
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.only(left: 4.0 + (widget.depth * 12)),
            color: isCurrent
                ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                : null,
            child: Row(
              children: [
                // Иконка развертывания
                RotationTransition(
                  turns: AlwaysStoppedAnimation(isOpen ? 0.25 : 0),
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  isCurrent ? Icons.folder_open_rounded : Icons.folder_rounded,
                  size: 20,
                  color: isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.folder.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isCurrent
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (isOpen)
          folderStream.when(
            data: (folders) => Column(
              children: folders
                  .where((f) => f.id != widget.folder.id)
                  .map((f) => FolderWidget(folder: f, depth: widget.depth + 1))
                  .toList(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(left: 20, top: 4, bottom: 4),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}
