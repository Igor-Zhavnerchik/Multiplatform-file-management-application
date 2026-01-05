import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateDialog extends ConsumerStatefulWidget {
  final bool createFolder;
  final FileEntity parent;
  const CreateDialog({
    required this.createFolder,
    required this.parent,
    super.key,
  });

  @override
  ConsumerState<CreateDialog> createState() => _CreateDialogState();
}

class _CreateDialogState extends ConsumerState<CreateDialog> {
  String name = '';
  late bool syncEnabled;
  late bool downloadEnabled;
  String? errorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final fileOpsVM = ref.read(fileOperationsViewModelProvider.notifier);
    syncEnabled = fileOpsVM.defaultSyncEnabled;
    downloadEnabled = fileOpsVM.defaultDownloadEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final dialogVM = ref.read(dialogViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return ModalDialogWindow(
      children: [
        // Заголовок
        Row(
          children: [
            Icon(
              widget.createFolder
                  ? Icons.create_new_folder_outlined
                  : Icons.insert_drive_file_outlined,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'New ${widget.createFolder ? 'Folder' : 'File'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Поле ввода
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'Enter name here...',
            errorText: errorMessage,
            prefixIcon: const Icon(Icons.edit_note),
          ),
          onChanged: (value) {
            name = value;
            if (errorMessage != null) setState(() => errorMessage = null);
          },
          onSubmitted: (_) => isLoading ? null : _onCreatePressed(),
        ),
        const SizedBox(height: 8),

        // Настройки (компактные)
        _buildToggleRow(
          icon: Icons.sync,
          label: 'Auto synchronization',
          value: syncEnabled,
          onChanged: (v) => setState(() => syncEnabled = v),
        ),
        _buildToggleRow(
          icon: Icons.file_download_outlined,
          label: 'Auto download',
          value: downloadEnabled,
          onChanged: (v) => setState(() => downloadEnabled = v),
        ),

        const SizedBox(height: 24),

        // Кнопки управления
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: isLoading ? null : () => dialogVM.hide(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: isLoading ? null : _onCreatePressed,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Create'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: isLoading ? null : onChanged,
      dense: true,
    );
  }

  void _onCreatePressed() async {
    if (name.trim().isEmpty) {
      setState(() => errorMessage = 'Name cannot be empty');
      return;
    }

    setState(() => isLoading = true);
    final result = await ref
        .read(fileOperationsViewModelProvider.notifier)
        .createFile(
          parent: widget.parent,
          isFolder: widget.createFolder,
          name: name.trim(),
          syncEnabled: syncEnabled,
          downloadEnabled: downloadEnabled,
        );

    if (!mounted) return;

    result.when(
      success: (_) => ref.read(dialogViewModelProvider.notifier).hide(),
      failure: (msg, _, __) => setState(() {
        errorMessage = msg;
        isLoading = false;
      }),
    );
  }
}
