import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/file_operations_view_model_provider.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationPanel extends ConsumerWidget implements PreferredSizeWidget {
  const NavigationPanel({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final homeState = ref.watch(homeViewModelProvider);

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return AppBar(
      backgroundColor: colorScheme.surfaceContainerHigh,
      elevation: 0,
      centerTitle: false,
      shape: Border(
        bottom: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      leadingWidth: 110,
      leading: const NavigationControls(),
      title: isMobile
          ? null
          : Text(
              'File Manager',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
      actions: [
        // --- КНОПКА ДЕЙСТВИЙ С ТЕКУЩЕЙ ПАПКОЙ ---
        _ActionButton(
          label: 'Scan',
          icon: Icons.search_rounded,
          isPrimary: false,
          onPressed: () =>
              ref.read(fileOperationsViewModelProvider.notifier).startScan(),
          hideLabel: isMobile,
        ),

        _ActionButton(
          label: 'Sync',
          icon: Icons.sync_rounded,
          isPrimary: false,
          hideLabel: isMobile,
          onPressed: () =>
              ref.read(fileOperationsViewModelProvider.notifier).startSync(),
        ),
        if (homeState.currentFolder != null)
          Builder(
            builder: (context) => _ActionButton(
              label: 'Folder',
              icon: Icons.add_box_outlined,
              isPrimary: true,
              hideLabel: isMobile,
              onPressed: () {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final Offset position = box.localToGlobal(Offset.zero);

                ref
                    .read(dialogViewModelProvider.notifier)
                    .showCustomDialog(
                      content: FolderOperationSelectMenu(
                        folder: homeState.currentFolder!,
                      ),
                      position: position + const Offset(-60, 50),
                    );
              },
            ),
          ),

        const VerticalDivider(width: 10, indent: 20, endIndent: 20),

        // --- КНОПКА ГЛОБАЛЬНЫХ НАСТРОЕК (ВМЕСТО POPUPMENU) ---
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset position = box.localToGlobal(Offset.zero);

              ref
                  .read(dialogViewModelProvider.notifier)
                  .showCustomDialog(
                    content: const _GlobalSettingsMenu(),
                    position: position + const Offset(-200, 50),
                  );
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// Новое меню настроек, построенное на вашей системе диалогов
class _GlobalSettingsMenu extends ConsumerWidget {
  const _GlobalSettingsMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return ContextDialogMenu(
      children: [
        ContextDialogSwitch(
          title: 'Auto-Download',
          icon: Icons.cloud_download_outlined,
          value: homeState.defaultDownloadEnabled,
          onChanged: (value) {
            ref
                .read(homeViewModelProvider.notifier)
                .toggleDefaultDownload(value);
          },
        ),
        const Divider(height: 1),
        ContextDialogOption(
          title: 'Sign Out',
          icon: Icons.logout_rounded,
          isDestructive: true,
          action: () => ref.read(authViewModelProvider.notifier).signOut(),
        ),
      ],
    );
  }
}

// Вспомогательные виджеты остаются практически без изменений,
// только обновляем стили для соответствия дизайну

class NavigationControls extends ConsumerWidget {
  const NavigationControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final notifier = ref.read(homeViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CircleNavButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: state.canGoBack ? () => notifier.goBack() : null,
          ),
          const SizedBox(width: 4),
          _CircleNavButton(
            icon: Icons.arrow_forward_ios_rounded,
            onPressed: state.canGoForward ? () => notifier.goForward() : null,
          ),
        ],
      ),
    );
  }
}

class _CircleNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CircleNavButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        disabledBackgroundColor: Colors.transparent,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool hideLabel;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.hideLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hideLabel) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        tooltip: label,
        style: IconButton.styleFrom(
          foregroundColor: isPrimary
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: isPrimary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
    );
  }
}
