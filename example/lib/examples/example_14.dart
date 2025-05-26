import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example14CustomAnimations extends StatefulWidget {
  final UpdateActionCallback updateAction;

  const Example14CustomAnimations({
    super.key,
    required this.updateAction,
  });

  @override
  State<Example14CustomAnimations> createState() =>
      _Example14CustomAnimationsState();
}

class _Example14CustomAnimationsState extends State<Example14CustomAnimations> {
  Duration _currentDuration = const Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 14: Custom Animations',
      description: 'Control animation speed:',
      content: SizedBox(
        width: double.infinity,
        height: 100, // Fixed height
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _currentDuration.inMilliseconds.toDouble(),
              min: 50,
              max: 1000,
              divisions: 19,
              label: '${_currentDuration.inMilliseconds}ms',
              onChanged: (value) {
                setState(() {
                  _currentDuration = Duration(milliseconds: value.round());
                  AwesomeContextMenu.setAnimationDuration(_currentDuration);
                });
                widget.updateAction(
                    'Animation duration set to ${value.round()}ms');
              },
            ),
            AwesomeContextMenuArea(
              animationDuration: _currentDuration,
              menuItems: [
                AwesomeContextMenuItem(
                  label: 'Speed: ${_currentDuration.inMilliseconds}ms',
                  icon: Icons.speed,
                  onSelected: () {},
                ),
                AwesomeContextMenuItem(
                  label: 'Animated item',
                  icon: Icons.animation,
                  onSelected: () => widget.updateAction(
                      'Selected with ${_currentDuration.inMilliseconds}ms animation'),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.animation, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Custom Animation Speed',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
