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

    return AppBar(
      // Используем чуть более темный/насыщенный тон для контраста
      backgroundColor: colorScheme.surfaceContainerHigh,
      elevation: 0,
      scrolledUnderElevation:
          4, // Усиливаем тень при прокрутке контента под панелью
      // Добавляем тонкую линию снизу для четкого отделения от контента
      shape: Border(
        bottom: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
      ),

      leadingWidth: 110,
      leading: const NavigationControls(),

      title: Text(
        'File Manager',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      actions: [
        _NavigationActionButton(
          label: 'Scan',
          icon: Icons.search_rounded,
          // Используем primary-стиль для важного действия
          isPrimary: false,
          onPressed: () =>
              ref.read(fileOperationsViewModelProvider.notifier).startScan(),
        ),
        _NavigationActionButton(
          label: 'Sync',
          icon: Icons.sync_rounded,
          isPrimary: true,
          onPressed: () =>
              ref.read(fileOperationsViewModelProvider.notifier).startSync(),
        ),
        const VerticalDivider(width: 20, indent: 15, endIndent: 15),
        IconButton(
          onPressed: () => ref.read(authViewModelProvider.notifier).signOut(),
          icon: const Icon(Icons.logout_rounded),
          tooltip: 'Sign Out',
          color: colorScheme.error,
        ),
        const SizedBox(width: 12),
      ],
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
      // Делаем кнопки полупрозрачными на фоне панели
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
        disabledBackgroundColor: Colors.transparent,
      ),
    );
  }
}

class _NavigationActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _NavigationActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: isPrimary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // Делаем рамку чуть заметнее
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
            ),
    );
  }
}
