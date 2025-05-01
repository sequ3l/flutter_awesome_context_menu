import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example16MenuPositioning extends StatefulWidget {
  final UpdateActionCallback updateAction;

  const Example16MenuPositioning({
    super.key,
    required this.updateAction,
  });

  @override
  State<Example16MenuPositioning> createState() => _Example16MenuPositioningState();
}

class _Example16MenuPositioningState extends State<Example16MenuPositioning> {
  Alignment _menuAlignment = Alignment.center;

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 16: Menu Positioning',
      description: 'Control menu positioning:',
      content: SizedBox(
        height: 200, // Fixed height to ensure proper layout
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Top Left'),
                  selected: _menuAlignment == Alignment.topLeft,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _menuAlignment = Alignment.topLeft);
                      widget.updateAction('Menu position set to top-left');
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('Center'),
                  selected: _menuAlignment == Alignment.center,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _menuAlignment = Alignment.center);
                      widget.updateAction('Menu position set to center');
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('Bottom Right'),
                  selected: _menuAlignment == Alignment.bottomRight,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _menuAlignment = Alignment.bottomRight);
                      widget.updateAction('Menu position set to bottom-right');
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: AwesomeContextMenuArea(
                  customPositionCallback: (rect, size) {
                    // Calculate position based on alignment
                    Offset position;
                    if (_menuAlignment == Alignment.topLeft) {
                      position = rect.topLeft;
                    } else if (_menuAlignment == Alignment.bottomRight) {
                      position = rect.bottomRight;
                    } else {
                      position = rect.center;
                    }
                    return position;
                  },
                  menuItems: [
                    AwesomeContextMenuItem(
                      label: 'Custom positioned item',
                      icon: Icons.place,
                      onSelected: () => widget.updateAction('Selected from custom position'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: 200,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade700, Colors.orange.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Menu appears at $_menuAlignment',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
