import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RenameDialog extends ConsumerStatefulWidget {
  final FileEntity entity;
  const RenameDialog({required this.entity, super.key});

  @override
  ConsumerState<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends ConsumerState<RenameDialog> {
  late String newName;
  String? errorMessage;
  bool isLoading = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    newName = widget.entity.name;
    _controller = TextEditingController(text: newName);

    final lastDotIndex = newName.lastIndexOf('.');
    final endOffset = (lastDotIndex > 0 && !widget.entity.isFolder)
        ? lastDotIndex
        : newName.length;

    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: endOffset,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onRenamePressed() async {
    if (newName.trim().isEmpty) {
      setState(() => errorMessage = 'Name cannot be empty');
      return;
    }
    setState(() => isLoading = true);
    final result = await ref
        .read(fileOperationsViewModelProvider.notifier)
        .renameFile(entity: widget.entity, newName: newName.trim());
    if (!mounted) return;
    result.when(
      success: (_) => ref.read(dialogViewModelProvider.notifier).hide(),
      failure: (msg, _, __) => setState(() {
        errorMessage = msg;
        isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalDialogWindow(
      children: [
        const Text(
          'Rename',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          autofocus: true,
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'New Name',
            errorText: errorMessage,
          ),
          onChanged: (v) => newName = v,
          onSubmitted: (_) => isLoading ? null : _onRenamePressed(),
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
              onPressed: isLoading ? null : _onRenamePressed,
              child: const Text('Rename'),
            ),
          ],
        ),
      ],
    );
  }
}
