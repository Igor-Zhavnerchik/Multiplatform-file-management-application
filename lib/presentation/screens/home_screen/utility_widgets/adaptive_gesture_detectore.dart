import 'dart:ui';

import 'package:flutter/material.dart';

class AdaptiveGestureDetector extends StatefulWidget {
  final Widget child;
  final HitTestBehavior? behavior;
  final GestureTapDownCallback? onSecondaryTapDownDesktop;
  final GestureLongPressStartCallback? onLongPressStartMobile;
  final VoidCallback? onDoubleTapDesktop;
  final VoidCallback? onDoubleTapMobile;
  final VoidCallback? onTapDesktop;
  final VoidCallback? onTapMobile;

  AdaptiveGestureDetector({
    required this.child,
    this.behavior,
    this.onSecondaryTapDownDesktop,
    this.onLongPressStartMobile,
    this.onDoubleTapDesktop,
    this.onDoubleTapMobile,
    this.onTapDesktop,
    this.onTapMobile,
    super.key,
  });

  @override
  State<AdaptiveGestureDetector> createState() =>
      _AdaptiveGestureDetectorState();
}

class _AdaptiveGestureDetectorState extends State<AdaptiveGestureDetector> {
  bool isDesktop = true;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        isDesktop =
            event.kind == PointerDeviceKind.mouse ||
            event.kind == PointerDeviceKind.trackpad;

        // buttons == 1 — это левая кнопка мыши
        // buttons == 0 — это касание пальцем (в зависимости от платформы)
        final isLeftClick = event.buttons == 1;
        final isTouch = event.kind == PointerDeviceKind.touch;

        if (isLeftClick || isTouch) {
          if (isDesktop) {
            widget.onTapDesktop?.call();
          } else {
            widget.onTapMobile?.call();
          }
        }
      },
      child: GestureDetector(
        behavior: widget.behavior ?? HitTestBehavior.opaque,
        // Оставляем onDoubleTap — он будет работать параллельно с Listener
        onDoubleTap: isDesktop
            ? widget.onDoubleTapDesktop
            : widget.onDoubleTapMobile,

        // ПКМ теперь снова будет ловиться здесь
        onSecondaryTapDown: isDesktop ? widget.onSecondaryTapDownDesktop : null,

        onLongPressStart: isDesktop ? null : widget.onLongPressStartMobile,

        // ВАЖНО: onTap в GestureDetector оставляем пустым,
        // чтобы он не конфликтовал с onDoubleTap и не создавал задержку,
        // так как логику выбора мы уже перенесли в Listener.
        onTap: () {},

        child: widget.child,
      ),
    );
  }
}
