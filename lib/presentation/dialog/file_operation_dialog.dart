import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/modal_windows/create_dialog_modal_window.dart';
import 'package:cross_platform_project/presentation/dialog/modal_windows/delete_dialog_modal_window.dart';
import 'package:cross_platform_project/presentation/dialog/modal_windows/rename_dialog_modal_window.dart';
import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileOperationSelectMenu extends ConsumerStatefulWidget {
  const FileOperationSelectMenu({required this.entity, super.key});
  final FileEntity entity;

  @override
  ConsumerState<FileOperationSelectMenu> createState() =>
      _FileOperationSelectMenuState();
}

class _FileOperationSelectMenuState
    extends ConsumerState<FileOperationSelectMenu> {
  late bool contentSyncEnabled;

  @override
  void initState() {
    super.initState();
    contentSyncEnabled = widget.entity.contentSyncEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final dialogVM = ref.read(dialogViewModelProvider.notifier);
    final fileOpsVM = ref.read(fileOperationsViewModelProvider.notifier);

    return ContextDialogMenu(
      children: [
        ContextDialogOption(
          title: 'Rename',
          icon: Icons.edit_outlined,
          action: () => dialogVM.showCustomDialog(
            content: RenameDialog(entity: widget.entity),
          ),
        ),
        ContextDialogOption(
          title: 'Copy',
          icon: Icons.copy_rounded,
          action: () =>
              fileOpsVM.setCopyFrom(isCut: false, copyFrom: widget.entity),
        ),
        ContextDialogOption(
          title: 'Cut',
          icon: Icons.content_cut_rounded,
          action: () =>
              fileOpsVM.setCopyFrom(isCut: true, copyFrom: widget.entity),
        ),
        const Divider(height: 1),
        ContextDialogSwitch(
          title: 'Syncronization',
          icon: Icons.sync,
          value: contentSyncEnabled,
          onChanged: (value) {
            setState(() => contentSyncEnabled = value);
            fileOpsVM.setContentSyncEnabled(
              entity: widget.entity,
              isEnabled: value,
            );
          },
        ),
        ContextDialogOption(
          title: 'Delete ${widget.entity.isFolder ? 'folder' : 'file'}',
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
          action: () => dialogVM.showCustomDialog(
            content: DeleteDialog(entity: widget.entity, localDelete: false),
          ),
        ),
        ContextDialogOption(
          title: 'Delete content',
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
          action: () => dialogVM.showCustomDialog(
            content: DeleteDialog(entity: widget.entity, localDelete: true),
          ),
        ),
      ],
    );
  }
}

class FolderOperationSelectMenu extends ConsumerWidget {
  const FolderOperationSelectMenu({required this.folder, super.key});
  final FileEntity folder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogVM = ref.read(dialogViewModelProvider.notifier);
    final fileOpsVM = ref.read(fileOperationsViewModelProvider.notifier);
    final fileOpsState = ref.watch(fileOperationsViewModelProvider);

    return ContextDialogMenu(
      children: [
        ContextDialogOption(
          title: 'Create File',
          icon: Icons.insert_drive_file_outlined,
          action: () => dialogVM.showCustomDialog(
            content: CreateDialog(createFolder: false, parent: folder),
          ),
        ),
        ContextDialogOption(
          title: 'Create Folder',
          icon: Icons.create_new_folder_outlined,
          action: () => dialogVM.showCustomDialog(
            content: CreateDialog(createFolder: true, parent: folder),
          ),
        ),
        const Divider(height: 1),
        ContextDialogOption(
          title: 'Add Files',
          icon: Icons.upload_file_rounded,
          action: () =>
              fileOpsVM.setPickedFiles(pickFolder: false, parent: folder),
        ),
        ContextDialogOption(
          title: 'Add Folder',
          icon: Icons.upload_file_rounded,
          action: () =>
              fileOpsVM.setPickedFiles(pickFolder: true, parent: folder),
        ),
        ContextDialogOption(
          title: 'Paste',
          icon: Icons.content_paste_rounded,
          enabled: fileOpsState.copyFrom != null,
          action: () => fileOpsVM.copyTo(folder: folder),
        ),
      ],
    );
  }
}

class ContextDialogMenu extends StatelessWidget {
  const ContextDialogMenu({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250, minWidth: 180),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class ContextDialogOption extends ConsumerWidget {
  const ContextDialogOption({
    required this.title,
    required this.action,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
    super.key,
  });

  final String title;
  final VoidCallback action;
  final IconData? icon;
  final bool isDestructive;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return Material(
      color: Colors.transparent, // Важно для просвечивания фона меню
      child: ListTile(
        onTap: enabled
            ? () {
                ref.read(dialogViewModelProvider.notifier).hide();
                action();
              }
            : null,
        enabled: enabled,
        dense: true,
        // Явно задаем hoverColor, так как в теме он может быть прозрачным
        hoverColor: color.withValues(alpha: 0.1),
        mouseCursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        leading: icon != null
            ? Icon(
                icon,
                color: color.withValues(alpha: enabled ? 1 : 0.5),
                size: 20,
              )
            : null,
        title: Text(
          title,
          style: TextStyle(
            color: color.withValues(alpha: enabled ? 1 : 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ContextDialogSwitch extends StatelessWidget {
  const ContextDialogSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
    this.icon,
    super.key,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        hoverColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: theme.colorScheme.onSurface),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              IgnorePointer(
                child: Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: value,
                    onChanged: (_) {},
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalDialogWindow extends StatelessWidget {
  const ModalDialogWindow({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 280),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
