import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'utils.dart';

class Example20KeyboardShortcuts extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example20KeyboardShortcuts({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 20: Keyboard Shortcuts',
      description: 'Menu with keyboard shortcut hints:',
      content: AwesomeContextMenuArea(
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Cut',
            icon: Icons.content_cut,
            shortcut: 'Ctrl+X',
            onSelected: () => updateAction('Cut selected'),
          ),
          AwesomeContextMenuItem(
            label: 'Copy',
            icon: Icons.content_copy,
            shortcut: 'Ctrl+C',
            onSelected: () => updateAction('Copy selected'),
          ),
          AwesomeContextMenuItem(
            label: 'Paste',
            icon: Icons.content_paste,
            shortcut: 'Ctrl+V',
            onSelected: () => updateAction('Paste selected'),
          ),
          AwesomeContextMenuItem.separator(),
          AwesomeContextMenuItem(
            label: 'Select All',
            icon: Icons.select_all,
            shortcut: 'Ctrl+A',
            onSelected: () => updateAction('Select All selected'),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                'Menu with Shortcuts',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
