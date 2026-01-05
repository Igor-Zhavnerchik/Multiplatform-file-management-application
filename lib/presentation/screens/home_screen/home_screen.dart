import 'package:cross_platform_project/presentation/providers/dialog_view_model_provider.dart';
import 'package:cross_platform_project/presentation/screens/home_screen/main_parts/file_view.dart';
import 'package:cross_platform_project/presentation/screens/home_screen/main_parts/folder_view.dart';
import 'package:cross_platform_project/presentation/screens/home_screen/main_parts/navigation_panel.dart';
import 'package:cross_platform_project/presentation/view_models/dialog_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final dialogState = ref.watch(dialogViewModelProvider);

    return Portal(
      child: PortalTarget(
        visible: dialogState.isVisible,
        portalFollower: _buildPortalOverlay(context, ref, dialogState),
        anchor: const Filled(),
        child: Scaffold(
          appBar: NavigationPanel(),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < 600
                  ? const MobileHomeScreen()
                  : const DesktopHomeScreen();
            },
          ),
        ),
      ),
    );
  }
}

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 250, child: FolderView()),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: FileView()),
      ],
    );
  }
}

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FileView();
  }
}

Widget _buildPortalOverlay(
  BuildContext context,
  WidgetRef ref,
  DialogState state,
) {
  if (!state.isVisible) return const SizedBox.shrink();

  final isContextMenu = state.position != null;

  return Stack(
    children: [
      if (!isContextMenu)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ref.read(dialogViewModelProvider.notifier).hide(),
            child: Container(color: Colors.black.withValues(alpha: 0.15)),
          ),
        ),

      if (isContextMenu)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ref.read(dialogViewModelProvider.notifier).hide(),
            child: Container(color: Colors.transparent),
          ),
        ),

      if (state.content != null)
        isContextMenu
            ? Positioned(
                left: state.position!.dx,
                top: state.position!.dy,
                child: _wrapInConstraints(context, state.content!),
              )
            : Center(child: _wrapInConstraints(context, state.content!)),
    ],
  );
}

Widget _wrapInConstraints(BuildContext context, Widget content) {
  final screenSize = MediaQuery.of(context).size;

  return ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: screenSize.width * 0.9,
      maxHeight: screenSize.height * 0.9,
    ),
    child: content,
  );
}
