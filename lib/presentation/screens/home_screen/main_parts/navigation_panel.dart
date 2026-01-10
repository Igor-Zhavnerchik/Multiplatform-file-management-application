import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
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
    // Определяем, узкий ли экран (мобильный)
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return AppBar(
      backgroundColor: colorScheme.surfaceContainerHigh,
      elevation: 0,
      centerTitle: false, // Выключаем центрирование для экономии места
      leadingWidth: 110, // Уменьшаем ширину на мобилках
      leading: const NavigationControls(),

      title: isMobile
          ? null
          : Text(
              'File Manager',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18, // Уменьшаем шрифт
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),

      actions: [
        _NavigationActionButton(
          label: 'Scan',
          icon: Icons.search_rounded,
          isPrimary: false,
          hideLabel: isMobile, // Скрываем текст
          onPressed: () =>
              ref.read(fileOperationsViewModelProvider.notifier).startScan(),
        ),
        _NavigationActionButton(
          label: 'Sync',
          icon: Icons.sync_rounded,
          isPrimary: true,
          hideLabel: isMobile, // Скрываем текст
          onPressed: () =>
              ref.read(fileOperationsViewModelProvider.notifier).startSync(),
        ),
        const VerticalDivider(width: 10, indent: 20, endIndent: 20),
        IconButton(
          onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
          icon: const Icon(Icons.logout_rounded, size: 20),
          tooltip: 'Sign Out',
          color: colorScheme.error,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _NavigationActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool hideLabel; // Добавили параметр

  const _NavigationActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.hideLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    // Если нужно скрыть текст, используем IconButton, иначе кнопку с текстом
    if (hideLabel) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        tooltip: label,
        style: IconButton.styleFrom(
          backgroundColor: isPrimary
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          foregroundColor: isPrimary
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : null,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: isPrimary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
            ),
    );
  }
}

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
      icon: Icon(icon, size: 18),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surface.withValues(alpha: 0.4),
        disabledBackgroundColor: Colors.transparent,
      ),
    );
  }
}
