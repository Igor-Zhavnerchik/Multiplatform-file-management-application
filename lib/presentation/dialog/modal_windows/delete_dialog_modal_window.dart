import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteDialog extends ConsumerStatefulWidget {
  final FileEntity entity;
  final bool localDelete;
  const DeleteDialog({
    required this.entity,
    super.key,
    required this.localDelete,
  });

  @override
  ConsumerState<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends ConsumerState<DeleteDialog> {
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return ModalDialogWindow(
      children: [
        Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            const Text(
              'Confirm Delete',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          'Are you sure you want to delete "${widget.entity.name}"? This action will delete this ${widget.entity.isFolder ? "folder" : "file"} from ${widget.localDelete ? "this device" : "all your devices"}.',
        ),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () =>
                  ref.read(dialogViewModelProvider.notifier).hide(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: isLoading ? null : _onDeletePressed,
              child: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }

  void _onDeletePressed() async {
    setState(() => isLoading = true);
    final result = await ref
        .read(fileOperationsViewModelProvider.notifier)
        .deleteFile(entity: widget.entity, localDelete: widget.localDelete);
    if (!mounted) return;
    result.when(
      success: (_) => ref.read(dialogViewModelProvider.notifier).hide(),
      failure: (msg, _, _) => setState(() {
        errorMessage = msg;
        isLoading = false;
      }),
    );
  }
}
