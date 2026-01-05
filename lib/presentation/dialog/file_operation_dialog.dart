import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/modal_windows/create_dialog_modal_window.dart';
import 'package:cross_platform_project/presentation/dialog/modal_windows/delete_dialog_modal_window.dart';
import 'package:cross_platform_project/presentation/dialog/modal_windows/rename_dialog_modal_window.dart';
import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* 
class AlertDialog extends ConsumerWidget {
  final String? message;
  AlertDialog({this.message});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CenteredPopUpMenu(children: [Text(message ?? 'Alert!')]);
  }
} */

class FileOperationSelectMenu extends ConsumerWidget {
  const FileOperationSelectMenu({required this.entity, super.key});
  final FileEntity entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogVM = ref.read(dialogViewModelProvider.notifier);
    final fileOpsVM = ref.read(fileOperationsViewModelProvider.notifier);

    return ContextDialogMenu(
      children: [
        ContextDialogOption(
          title: 'Rename',
          icon: Icons.edit_outlined,
          action: () =>
              dialogVM.showCustomDialog(content: RenameDialog(entity: entity)),
        ),
        ContextDialogOption(
          title: 'Copy',
          icon: Icons.copy_rounded,
          action: () => fileOpsVM.setCopyFrom(isCut: false, copyFrom: entity),
        ),
        ContextDialogOption(
          title: 'Cut',
          icon: Icons.content_cut_rounded,
          action: () => fileOpsVM.setCopyFrom(isCut: true, copyFrom: entity),
        ),
        const Divider(height: 1),
        ContextDialogOption(
          title: 'Delete',
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
          action: () =>
              dialogVM.showCustomDialog(content: DeleteDialog(entity: entity)),
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
          action: () => fileOpsVM.setPickedFiles(pickFolder: false),
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
        // Ограничиваем ширину выпадающего меню
        constraints: const BoxConstraints(maxWidth: 250, minWidth: 160),
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
        // Используем Clip.antiAlias чтобы ListTile не вылезал за скругления
        clipBehavior: Clip.antiAlias,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // А здесь stretch нужен для ListTile
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
  final IconData? icon; // Заменил на IconData для удобства
  final bool isDestructive;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return ListTile(
      onTap: () {
        ref.read(dialogViewModelProvider.notifier).hide();
        action();
      },
      enabled: enabled,
      dense: true,
      leading: icon != null
          ? Icon(icon, color: color.withOpacity(enabled ? 1 : 0.5), size: 20)
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: color.withOpacity(enabled ? 1 : 0.5),
          fontWeight: FontWeight.w500,
        ),
      ),
      visualDensity: VisualDensity.compact,
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
      // Центрируем для модальных окон
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(
            maxWidth: 400, // Ограничиваем максимальную ширину диалога
            minWidth: 280, // Но не даем ему быть слишком узким
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              24,
            ), // В Material 3 скругления больше
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
            mainAxisSize: MainAxisSize.min, // Схлопываем по высоте
            crossAxisAlignment:
                CrossAxisAlignment.start, // Контент не растягивается вширь
            children: children,
          ),
        ),
      ),
    );
  }
}
