import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example19ProgrammaticMenu extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example19ProgrammaticMenu({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 19: Programmatic Menu',
      description: 'Open menu programmatically:',
      content: Center(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              _showContextMenu(context);
              updateAction('Menu triggered programmatically');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_open, size: 16),
                SizedBox(width: 8),
                Text('Show Context Menu'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    // Get button position to show menu near it
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);
    final Size size = button.size;

    // Show menu at the bottom of the button
    AwesomeContextMenu.show(
      context: context,
      items: [
        AwesomeContextMenuItem(
          label: 'Programmatic item 1',
          icon: Icons.add_circle,
          onSelected: () => updateAction('Programmatic item 1 selected'),
        ),
        AwesomeContextMenuItem(
          label: 'Programmatic item 2',
          icon: Icons.remove_circle,
          onSelected: () => updateAction('Programmatic item 2 selected'),
        ),
      ],
      position: Offset(position.dx + size.width / 2, position.dy + size.height),
      maxMenuWidth: 200.0,
    );
  }
}
