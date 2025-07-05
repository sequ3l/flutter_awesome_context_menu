import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A custom gesture recognizer that ALWAYS wins the gesture arena for right-clicks
class RightClickGestureRecognizer extends OneSequenceGestureRecognizer {
  final void Function(Offset position)? onRightClick;

  RightClickGestureRecognizer({this.onRightClick});

  @override
  void addAllowedPointer(PointerDownEvent event) {
    // Only handle right-click events
    if (event.buttons == kSecondaryMouseButton) {
      startTrackingPointer(event.pointer, event.transform);
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent && event.buttons == kSecondaryMouseButton) {
      // Call our callback and ensure we maintain control
      onRightClick?.call(event.position);
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'right-click';

  @override
  void didStopTrackingLastPointer(int pointer) {
    // Ensure we resolve as accepted when stopping tracking
    resolve(GestureDisposition.accepted);
  }
}

/// A gesture detector that uses the custom recognizer to ALWAYS win right-clicks
class SuperRightClickDetector extends StatelessWidget {
  final Widget child;
  final void Function(Offset position)? onRightClick;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SuperRightClickDetector({
    super.key,
    required this.child,
    this.onRightClick,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        RightClickGestureRecognizer: GestureRecognizerFactoryWithHandlers<RightClickGestureRecognizer>(
          () => RightClickGestureRecognizer(onRightClick: onRightClick),
          (RightClickGestureRecognizer instance) {},
        ),
        // Also handle left clicks normally
        if (onTap != null)
          TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
            () => TapGestureRecognizer(),
            (TapGestureRecognizer instance) {
              instance.onTap = onTap;
            },
          ),
        // Handle long press for mobile platforms
        if (onLongPress != null)
          LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(),
            (LongPressGestureRecognizer instance) {
              instance.onLongPress = onLongPress;
            },
          ),
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
