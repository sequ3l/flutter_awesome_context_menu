import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example9PersistentMenu extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example9PersistentMenu({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    return buildExampleCard(
      title: 'Example 9: Persistent Menu',
      description: 'Menu stays open after selection:',
      content: AwesomeContextMenuArea(
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Apply Bold Formatting',
            icon: Icons.format_bold,
            onSelected: () => updateAction('Bold formatting applied ✓'),
            dismissMenuOnSelect: false, // Keep menu open
          ),
          AwesomeContextMenuItem(
            label: 'Apply Italic Formatting',
            icon: Icons.format_italic,
            onSelected: () => updateAction('Italic formatting applied ✓'),
            dismissMenuOnSelect: false, // Keep menu open
          ),
          AwesomeContextMenuItem(
            label: 'Apply Underline Formatting',
            icon: Icons.format_underline,
            onSelected: () => updateAction('Underline formatting applied ✓'),
            dismissMenuOnSelect: false, // Keep menu open
          ),
          AwesomeContextMenuItem.separator(),
          AwesomeContextMenuItem(
            label: 'Close Menu',
            icon: Icons.close,
            onSelected: () => updateAction('Menu closed'),
            // Default behavior is to close the menu (dismissMenuOnSelect = true)
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3F51B5),
                Color(0xFF2196F3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3F51B5).withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.format_shapes,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Formatting Options',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
