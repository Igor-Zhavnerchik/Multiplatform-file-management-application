import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ContextDialogType {
  inFolderMenu,
  optionMenu,
  createFile,
  createFolder,
  addEntity,
  update,
  delete,
  copy,
  cut,
  paste,
}

class ContextDialog extends ConsumerWidget {
  ContextDialog({
    required this.dialog,
    required this.position,
    required this.dialogContext,
    super.key,
  });

  final ContextDialogType dialog;
  final Offset? position;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (dialog) {
      ContextDialogType.inFolderMenu => InFolderMenu(position: position!),
      ContextDialogType.optionMenu => OptionMenu(position: position!),
      ContextDialogType.createFile => CreateFileDialog(),
      ContextDialogType.createFolder => CreateFolderDialog(),
      ContextDialogType.addEntity => AddEntityDialog(),
      ContextDialogType.update => UpdateDialog(),
      ContextDialogType.delete => DeleteDialog(),
      _ => AlertDialog(),
    };
  }
}

class AlertDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CenteredPopUpMenu(children: [Text('Alert!')]);
  }
}

class DeleteDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CenteredPopUpMenu(
      children: [
        Text('Delete this file?'),
        Row(
          children: [
            DialogButton(
              onPressed: () => ref
                  .read(fileOperationsViewModelProvider.notifier)
                  .deleteFile(),

              text: 'Delete',
              closeOnApply: true,
            ),
            DialogButton(onPressed: () {}, text: 'Cancel', closeOnApply: true),
          ],
        ),
      ],
    );
  }
}

class UpdateDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class CreateFileDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CenteredPopUpMenu(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'File Name: '),
          onChanged: (value) => ref
              .read(fileOperationsViewModelProvider.notifier)
              .setNewFileState(name: value),
        ),

        Row(
          children: [
            DialogButton(
              onPressed: () => ref
                  .read(fileOperationsViewModelProvider.notifier)
                  .createFile(isFolder: false),

              text: 'Create',
              closeOnApply: true,
            ),
            DialogButton(onPressed: () {}, text: 'Cancel', closeOnApply: true),
          ],
        ),
      ],
    );
  }
}

class CreateFolderDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CenteredPopUpMenu(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Folder Name: '),
          onChanged: (value) => ref
              .read(fileOperationsViewModelProvider.notifier)
              .setNewFileState(name: value),
        ),

        Row(
          children: [
            DialogButton(
              onPressed: () => ref
                  .read(fileOperationsViewModelProvider.notifier)
                  .createFile(isFolder: true),
              text: 'Create',
              closeOnApply: true,
            ),
            DialogButton(onPressed: () {}, text: 'Cancel', closeOnApply: true),
          ],
        ),
      ],
    );
  }
}

class AddEntityDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(fileOperationsViewModelProvider.notifier);
    return CenteredPopUpMenu(
      children: [
        Row(
          children: [
            DialogButton(
              onPressed: () => ref
                  .watch(fileOperationsViewModelProvider.notifier)
                  .getNewFilePath(),
              text: 'Pick Path',
            ),
            Text(
              'path: ${ref.read(fileOperationsViewModelProvider).newFileLocalPath}',
            ),
          ],
        ),

        Row(
          children: [
            DialogButton(
              onPressed: () => ref
                  .read(fileOperationsViewModelProvider.notifier)
                  .createFile(isFolder: false),
              text: 'Add',
              closeOnApply: true,
            ),
            DialogButton(onPressed: () {}, text: 'Cancel', closeOnApply: true),
          ],
        ),
      ],
    );
  }
}

class OptionMenu extends ConsumerWidget {
  OptionMenu({required this.position, super.key});

  final Offset position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DialogMenu(
      position: position,
      children: [
        DialogOption(dialog: ContextDialogType.delete, text: 'Delete'),
        DialogOption(dialog: ContextDialogType.update, text: 'Edit'),
        DialogOption(
          dialog: ContextDialogType.copy,
          text: 'Copy',
          action: () => ref
              .read(fileOperationsViewModelProvider.notifier)
              .setCopyFrom(isCut: false),
        ),
        DialogOption(
          dialog: ContextDialogType.cut,
          text: 'Cut',
          action: () => ref
              .read(fileOperationsViewModelProvider.notifier)
              .setCopyFrom(isCut: true),
        ),
      ],
    );
  }
}

class InFolderMenu extends ConsumerWidget {
  InFolderMenu({required this.position, super.key});

  final Offset position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DialogMenu(
      position: position,
      children: [
        DialogOption(dialog: ContextDialogType.createFile, text: 'Create File'),
        DialogOption(
          dialog: ContextDialogType.createFolder,
          text: 'Create Folder',
        ),
        DialogOption(dialog: ContextDialogType.addEntity, text: 'Add existing'),
        DialogOption(
          dialog: ContextDialogType.paste,
          text: 'Paste',
          action: () =>
              ref.read(fileOperationsViewModelProvider.notifier).copyTo(),
        ),
      ],
    );
  }
}

class DialogOption extends ConsumerWidget {
  DialogOption({
    required this.dialog,
    required this.text,
    this.action,
    super.key,
  });

  final ContextDialogType dialog;
  final String text;
  final Function? action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (action != null) {
          action!();
        }
        Navigator.of(context).pop(dialog);
      },
      child: Padding(padding: EdgeInsets.all(10), child: Text(text)),
    );
  }
}

class DialogButton extends ConsumerWidget {
  DialogButton({
    required this.onPressed,
    required this.text,
    this.closeOnApply = false,
    super.key,
  });

  final Function() onPressed;
  final String text;
  final bool closeOnApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: () {
        onPressed();
        if (closeOnApply) {
          Navigator.of(context).pop();
        }
      },
      child: Text(text),
    );
  }
}

class DialogMenu extends ConsumerWidget {
  DialogMenu({required this.children, required this.position, super.key});

  final List<DialogOption> children;
  final Offset position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Material(elevation: 4, child: Column(children: children)),
        ),
      ],
    );
  }
}

class CenteredPopUpMenu extends ConsumerWidget {
  CenteredPopUpMenu({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Center(
          child: IntrinsicWidth(
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
