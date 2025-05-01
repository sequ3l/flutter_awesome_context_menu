import 'package:flutter/material.dart';
import 'package:flutter_awesome_context_menu/flutter_awesome_context_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils.dart';

class Example6Grouping extends StatelessWidget {
  final UpdateActionCallback updateAction;

  const Example6Grouping({
    super.key,
    required this.updateAction,
  });

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return buildExampleCard(
      title: 'Example 6: Grouped Items',
      description: 'Menu with item grouping:',
      content: AwesomeContextMenuArea(
        menuItems: [
          AwesomeContextMenuItem(
            label: 'Edit Content',
            icon: Icons.edit,
            onSelected: () => updateAction('Edit selected'),
          ),
          AwesomeContextMenuItem(
            label: 'Copy Text',
            icon: Icons.content_copy,
            onSelected: () => updateAction('Copy selected'),
          ),
          AwesomeContextMenuItem.separator(),
          AwesomeContextMenuItem(
            label: 'Share',
            icon: Icons.share,
            onSelected: () => updateAction('Share selected'),
          ),
          AwesomeContextMenuItem(
            label: 'Download',
            icon: Icons.download,
            onSelected: () => updateAction('Download selected'),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                secondaryColor,
                secondaryColor.withBlue(255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: secondaryColor.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.menu,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Grouped menu items',
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
