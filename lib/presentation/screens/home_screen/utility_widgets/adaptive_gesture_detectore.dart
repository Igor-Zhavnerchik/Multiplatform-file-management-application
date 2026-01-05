import 'dart:ui';

import 'package:cross_platform_project/core/debug/debugger.dart';
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
        debugLog('detected ${isDesktop ? 'desktop' : 'mobile'} pointer event');
      },

      child: GestureDetector(
        behavior: widget.behavior,
        onTap: () {
          if (isDesktop) {
            widget.onTapDesktop?.call();
          } else {
            widget.onTapMobile?.call();
          }
        },
        onDoubleTap: isDesktop
            ? widget.onDoubleTapDesktop
            : widget.onDoubleTapMobile,
        onSecondaryTapDown: isDesktop ? widget.onSecondaryTapDownDesktop : null,
        onLongPressStart: isDesktop ? null : widget.onLongPressStartMobile,
        child: widget.child,
      ),
    );
  }
}
